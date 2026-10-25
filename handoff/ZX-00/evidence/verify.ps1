# Document delivery checks only, never application acceptance tests.
$ErrorActionPreference = 'Stop'
$taskRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../../..')).Path
Set-Location -LiteralPath $taskRoot
$taskChecks = [System.Collections.Generic.List[object]]::new()
function Add-Check([string]$Id, [bool]$Passed, [string]$Detail) {
    $taskChecks.Add([ordered]@{ id = $Id; passed = $Passed; detail = $Detail })
}
$taskRequired = @(
    '.gitignore', 'README.md', 'docs/INVENTORY.md', 'docs/GAP_ANALYSIS.md',
    'docs/BOOTSTRAP.md', 'handoff/ZX-00/TASK.md', 'handoff/ZX-00/CHANGES.md',
    'handoff/ZX-00/TEST_EVIDENCE.md', 'handoff/ZX-00/KNOWN_ISSUES.md',
    'handoff/ZX-00/review_request.md', 'handoff/ZX-00/evidence/initial-files.json',
    'handoff/ZX-00/evidence/SUMMARY.md', 'handoff/ZX-00/evidence/collect.ps1',
    'handoff/ZX-00/evidence/verify.ps1'
)
$taskMissing = @($taskRequired | Where-Object { -not (Test-Path -LiteralPath $_ -PathType Leaf) })
Add-Check 'delivery-files' ($taskMissing.Count -eq 0) ("required=$($taskRequired.Count); missing=$($taskMissing -join ',')")

$taskBaseline = @(Get-Content -LiteralPath 'handoff/ZX-00/evidence/initial-files.json' -Raw | ConvertFrom-Json)
$taskOriginalOk = $taskBaseline.Count -eq 1
foreach ($taskFile in $taskBaseline) {
    $taskCurrent = Get-Item -LiteralPath $taskFile.path
    $taskHash = (Get-FileHash -LiteralPath $taskFile.path -Algorithm SHA256).Hash
    $taskOriginalOk = $taskOriginalOk -and ($taskCurrent.Length -eq $taskFile.bytes) -and ($taskHash -eq $taskFile.sha256)
}
Add-Check 'original-unchanged' $taskOriginalOk 'Original planning file size and SHA-256 compared with initial snapshot.'

$taskBranch = (& git branch --show-current).Trim()
Add-Check 'task-branch' ($taskBranch -eq 'feat/ZX-00-inventory') $taskBranch
& git merge-base --is-ancestor c676fafa7e8029dd0b407af5298d22a65e124ff3 HEAD
Add-Check 'baseline-ancestor' ($LASTEXITCODE -eq 0) 'Task HEAD descends from the remote initialization commit.'

foreach ($taskScript in @('collect.ps1', 'verify.ps1')) {
    $taskTokens = $null
    $taskErrors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile((Join-Path $PSScriptRoot $taskScript), [ref]$taskTokens, [ref]$taskErrors)
    Add-Check ('syntax-' + $taskScript) (@($taskErrors).Count -eq 0) ("parse_errors=$(@($taskErrors).Count)")
}

$taskIgnoredPaths = @(
    '.env', 'private/example.txt', 'uploads/example.txt',
    'handoff/ZX-00/evidence/baseline/results.json',
    'handoff/ZX-00/evidence/local-bootstrap.json',
    'handoff/ZX-00/evidence/local-delivery.json',
    'handoff/ZX-00/evidence/local-fetch.stderr.txt',
    'handoff/ZX-00/evidence/runs/example/results.json'
)
$taskNotIgnored = @()
foreach ($taskPath in $taskIgnoredPaths) {
    & git check-ignore --no-index -q -- $taskPath
    if ($LASTEXITCODE -ne 0) { $taskNotIgnored += $taskPath }
}
Add-Check 'private-path-exclusions' ($taskNotIgnored.Count -eq 0) ("checked=$($taskIgnoredPaths.Count); not_ignored=$($taskNotIgnored -join ',')")

# Limited high-confidence scanning; report only path/line, never matching values.
$taskPatterns = @(
    '-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----',
    '(?<![A-Za-z0-9])(?:ghp|gho|ghu|ghs|github_pat)_[A-Za-z0-9_]{20,}',
    '(?<![A-Za-z0-9])sk-[A-Za-z0-9_-]{20,}',
    '(?i)[A-Z]:[\\/](?:Users|zuomian)[\\/]'
)
$taskScanFiles = @($taskRequired + @($taskBaseline | ForEach-Object path)) | Select-Object -Unique
$taskFindings = @()
foreach ($taskPath in $taskScanFiles) {
    $taskLines = @(Get-Content -LiteralPath $taskPath)
    for ($taskLine = 0; $taskLine -lt $taskLines.Count; $taskLine++) {
        foreach ($taskPattern in $taskPatterns) {
            if ($taskLines[$taskLine] -match $taskPattern) {
                $taskFindings += ($taskPath + ':' + ($taskLine + 1))
            }
        }
    }
}
Add-Check 'limited-sensitive-pattern-scan' ($taskFindings.Count -eq 0) ("files=$($taskScanFiles.Count); findings=$($taskFindings -join ','); not a complete security audit")

$taskFailures = @($taskChecks | Where-Object { -not $_.passed }).Count
$taskReport = [ordered]@{
    task_id = 'ZX-00'; checked_at = (Get-Date -Format o)
    category = 'documentation_delivery_integrity_not_application_tests'
    checks = @($taskChecks.ToArray()); check_count = $taskChecks.Count; failed = $taskFailures
    application_tests_executed = 0; application_test_failures = $null
} | ConvertTo-Json -Depth 6
[System.IO.File]::WriteAllText((Join-Path $PSScriptRoot 'verification.json'), ($taskReport.Replace("`r`n", "`n") + "`n"), [System.Text.UTF8Encoding]::new($false))
Write-Output ("Delivery integrity checks=$($taskChecks.Count), failed=$taskFailures; application tests=NOT_RUN")
if ($taskFailures -gt 0) { exit 1 }
