param([string]$OutputDirectory = '')

# ZX-00 read-only inspection. Writes evidence only; never installs, starts services,
# reads credential values, contacts providers, initializes Git, or changes branches.
$ErrorActionPreference = 'Stop'
$taskRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../../..')).Path
if (-not $OutputDirectory) {
    $OutputDirectory = Join-Path $PSScriptRoot ('runs/' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
}
$taskOutput = [System.IO.Path]::GetFullPath($OutputDirectory)
New-Item -ItemType Directory -Path $taskOutput -Force | Out-Null
$taskResults = [System.Collections.Generic.List[object]]::new()
Set-Location -LiteralPath $taskRoot

function Invoke-RecordedCommand {
    param([string]$Id, [string]$Executable, [string[]]$Arguments)
    $taskStdout = Join-Path $taskOutput ($Id + '.stdout.txt')
    $taskStderr = Join-Path $taskOutput ($Id + '.stderr.txt')
    $taskStarted = Get-Date -Format o
    $taskExitCode = $null
    $taskStatus = 'executed'
    '' | Set-Content -LiteralPath $taskStdout -Encoding utf8 -NoNewline
    '' | Set-Content -LiteralPath $taskStderr -Encoding utf8 -NoNewline
    if (-not (Get-Command $Executable -ErrorAction SilentlyContinue)) {
        $taskStatus = 'unavailable'
        "Collector: executable not found: $Executable (no process started)." |
            Set-Content -LiteralPath $taskStderr -Encoding utf8
    } else {
        $taskSavedPreference = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        try {
            $global:LASTEXITCODE = $null
            & $Executable @Arguments 1> $taskStdout 2> $taskStderr
            $taskExitCode = $global:LASTEXITCODE
        } catch {
            $taskStatus = 'invocation_error'
            $_.Exception.Message | Add-Content -LiteralPath $taskStderr -Encoding utf8
        } finally {
            $ErrorActionPreference = $taskSavedPreference
        }
    }
    $taskResults.Add([ordered]@{
        id = $Id; executable = $Executable; arguments = $Arguments
        cwd = $taskRoot; started_at = $taskStarted; ended_at = (Get-Date -Format o)
        status = $taskStatus; exit_code = $taskExitCode
        stdout = [System.IO.Path]::GetFileName($taskStdout)
        stderr = [System.IO.Path]::GetFileName($taskStderr)
    })
    Write-Output ("{0}: status={1}, exit={2}" -f $Id, $taskStatus, $taskExitCode)
}

$taskShell = Join-Path $PSHOME 'pwsh.exe'
Invoke-RecordedCommand '01-environment' $taskShell @('-NoProfile', '-Command', '[ordered]@{ os = [System.Runtime.InteropServices.RuntimeInformation]::OSDescription; architecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString(); powershell = $PSVersionTable.PSVersion.ToString(); local_time = (Get-Date -Format o); timezone = (Get-TimeZone).Id; cwd = (Get-Location).Path } | ConvertTo-Json')
Invoke-RecordedCommand '02-git-status' 'git' @('status', '--short', '--branch')
Invoke-RecordedCommand '03-git-root' 'git' @('rev-parse', '--show-toplevel')
Invoke-RecordedCommand '04-git-head' 'git' @('rev-parse', 'HEAD')
Invoke-RecordedCommand '05-git-branch' 'git' @('branch', '--show-current')
Invoke-RecordedCommand '06-source-files' 'rg' @('--files', '--hidden', '-g', '!.git', '-g', '!node_modules', '-g', '!docs', '-g', '!handoff')
Invoke-RecordedCommand '07-required-paths' $taskShell @('-NoProfile', '-Command', '$taskPaths = @(".git", "README.md", "AGENTS.md", "contracts/openapi.yaml", "apps/mobile", "package.json", "pyproject.toml", "requirements.txt", "alembic.ini", "alembic", "migrations", "tests", "backend", "apps/api", "app.json", "app.config.ts", "eas.json", "Dockerfile", "compose.yaml", "docker-compose.yml", ".env.example"); @($taskPaths | ForEach-Object { [ordered]@{ path = $_; exists = (Test-Path -LiteralPath $_) } }) | ConvertTo-Json')
Invoke-RecordedCommand '08-code-and-config-search' $taskShell @('-NoProfile', '-Command', '$taskFiles = @(Get-ChildItem -Force -Recurse -File | Where-Object { $_.FullName -notmatch "[\\/](handoff|docs|node_modules|\.git)[\\/]" -and ($_.Extension -in @(".py", ".ts", ".tsx", ".js", ".jsx", ".sql", ".yaml", ".yml", ".json", ".toml", ".lock", ".sh", ".ps1", ".apk", ".db", ".sqlite", ".sqlite3") -or $_.Name -match "^(Dockerfile|Makefile|requirements.*\.txt|\.env.*|.*lock.*)$") }); [ordered]@{ matching_file_count = $taskFiles.Count; files = @($taskFiles | ForEach-Object { [System.IO.Path]::GetRelativePath((Get-Location).Path, $_.FullName) }) } | ConvertTo-Json')
Invoke-RecordedCommand '09-git-version' 'git' @('--version')
Invoke-RecordedCommand '10-rg-version' 'rg' @('--version')
Invoke-RecordedCommand '11-python-version' 'python' @('--version')
Invoke-RecordedCommand '12-node-version' 'node' @('--version')
Invoke-RecordedCommand '13-npm-version' 'npm' @('--version')
Invoke-RecordedCommand '14-docker-version' 'docker' @('--version')
Invoke-RecordedCommand '15-psql-version' 'psql' @('--version')
Invoke-RecordedCommand '16-adb-version' 'adb' @('version')
Invoke-RecordedCommand '17-java-version' 'java' @('-version')

[ordered]@{
    task_id = 'ZX-00'; root = $taskRoot
    collected_at = (Get-Date -Format o); output_directory = $taskOutput
    application_tests_executed = 0; application_test_failures = $null
    application_tests_status = 'NOT_RUN_SOURCE_AND_ENTRYPOINTS_MISSING'
    notes = 'CLI availability is not application validation. Null test failures means not measured. No service or provider was contacted.'
    commands = @($taskResults.ToArray())
} | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $taskOutput 'results.json') -Encoding utf8
Write-Output ('Evidence: ' + $taskOutput)
