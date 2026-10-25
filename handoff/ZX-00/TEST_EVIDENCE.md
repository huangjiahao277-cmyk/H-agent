# ZX-00 测试与检查证据

## 环境、时间和证据

2026-10-25，Asia/Shanghai。本机 Windows `10.0.26200` / X64；PowerShell `7.6.5`。检查开始时未初始化 Git。基线采集命令：

```powershell
& './handoff/ZX-00/evidence/collect.ps1' -OutputDirectory './handoff/ZX-00/evidence/baseline'
```

完整命令参数、时间、cwd、退出码保存在本机 `evidence/baseline/results.json`；每条命令对应 `<编号>.stdout.txt` 和 `<编号>.stderr.txt`。本机绝对路径未复制到公开摘要。公开摘要见 `evidence/SUMMARY.md`。原始日志被忽略，不随 Git 提交；接收人可复跑脚本产生自己的证据。早期 pre-bootstrap 采集的退出码为空，不参与统计；baseline 使用修正后的采集器。

## 实际结果摘要

| 证据 ID | 实际命令／检查 | stdout 摘要 | stderr／退出状态 |
| --- | --- | --- | --- |
| 01 | PowerShell 环境 JSON | Windows、X64、PS 7.6.5、时区和检查根目录 | 空；0 |
| 02 | `git status --short --branch` | 空 | `fatal: not a git repository (or any of the parent directories): .git`；128 |
| 03 | `git rev-parse --show-toplevel` | 空 | 同上；128 |
| 04 | `git rev-parse HEAD` | 空 | 同上；128 |
| 05 | `git branch --show-current` | 空 | 同上；128 |
| 06 | `rg --files --hidden -g !.git -g !node_modules -g !docs -g !handoff` | 仅 `专属成长型Agent项目规划.md` | 空；0 |
| 07 | 21 个约定工程入口 `Test-Path` | `.git`、README、OpenAPI、apps/mobile、依赖／迁移／测试等均为 false | 空；0 |
| 08 | 代码／配置／数据库／APK 文件递归搜索（排除新交付目录） | `matching_file_count: 0`, `files: []` | 空；0 |
| 09 | `git --version` | `git version 2.55.0.windows.3` | 空；0 |
| 10 | `rg --version` | 实际全文见 baseline/10 文件；工具可用 | 空；0 |
| 11 | `python --version` | 空 | `Python was not found; run without arguments to install from the Microsoft Store...`；9009 |
| 12 | `node --version` | `v24.18.0` | 空；0 |
| 13 | `npm --version` | `11.16.0` | 空；0 |
| 14 | `docker --version` | 未启动进程 | 采集器报告 PATH 中无命令；exit_code=null |
| 15 | `psql --version` | 未启动进程 | 采集器报告 PATH 中无命令；exit_code=null |
| 16 | `adb version` | `Android Debug Bridge version 1.0.41`, `37.0.1-15733141` | 空；0；未枚举或连接设备 |
| 17 | `java -version` | 空 | 正常版本信息位于 stderr：OpenJDK `17.0.20.1`；0 |

17 项检查：15 个进程实际执行，10 项退出 0，5 项非零（4 项初始非 Git + 1 项 Python 别名失效）；2 项命令缺失、未启动进程。它们是库存／工具检查，不是应用测试。Java stderr 有版本信息不等于失败。

## 应用测试、类型与构建

| 验证 | 执行数量 | 失败数量 | 状态／原因 |
| --- | --- | --- | --- |
| 后端单元／集成／安全测试 | 0 | 未测量 | 未测试；无源码、测试、依赖清单 |
| 移动端测试／lint／TypeScript 检查 | 0 | 未测量 | 未测试；无 package.json、脚本或 tsconfig |
| 后端构建／导入／启动 | 0 | 未测量 | 未测试；无入口或构建配置 |
| Alembic 迁移与回滚 | 0 | 未测量 | 未测试；无迁移和数据库连接 |
| MiMo / DeepSeek 真实联调 | 0 | 未测量 | 待验收；未访问凭据或供应商 |
| Expo Go／模拟器／Release APK／真机 | 0 | 未测量 | 未测试；无工程及产物 |
| PAD/TTS、恢复、备份恢复、E2E | 0 | 未测量 | 未测试；无实现与受控运行环境 |

没有运行与仓库无关的空 pytest／npm／构建命令，没有 Mock 通过或 Release 通过声明。

## 库存交付核验索引

下列 INV 为本任务自定义检查索引，非权威 AC 编号。

| 索引 | 核验内容 | 证据 |
| --- | --- | --- |
| INV-01 | 初始只有规划文件，未篡改原文 | initial-files.json；verification.json |
| INV-02 | 初始 Git／依赖／前后端／测试／迁移缺失 | baseline/02–08 原始文件；SUMMARY.md |
| INV-03 | 实测本机工具、保留非零与缺失结果 | baseline/01、09–17；SUMMARY.md |
| INV-04 | 三份 docs 与五件套齐全、脚本可解析 | verification.json |
| INV-05 | 任务分支与起始 SHA | TASK.md；PR head／本地 Git |
| INV-06 | 规划差异和权威输入缺失已报告 | GAP_ANALYSIS.md；KNOWN_ISSUES.md |
| INV-07 | 有限敏感模式扫描与本机日志不提交 | verification.json；Git 暂存清单复核 |

正式 AC-MODEL / COGNITION / STICKER / VOICE / AFFECT / SEC / OPS 全部未测试，具体用例编号待规范原文提供。交付完整性通过不能代替这些功能验收。

## 交付完整性与格式检查

实际执行 `& './handoff/ZX-00/evidence/verify.ps1'`：stdout 为 `Delivery integrity checks=8, failed=0; application tests=NOT_RUN`，退出 0。包括 14 个必需交付文件、原始规划大小及哈希、任务分支、基线祖先、两份脚本解析、8 个隐私忽略路径和 15 个文件的有限敏感模式检查。最后结果保存在 verification.json。

第一次 `git diff --cached --check` 返回 2：生成 JSON 的 CRLF 被识别为行末空白，另有原始规划第 3、4 行原有的 Markdown 两空格换行。生成 JSON 已改为 LF，脚本输出亦改为 LF；原始规划保持字节不变。最终新增交付使用 `git diff --cached --check -- . ':(exclude)专属成长型Agent项目规划.md'` 检查；原始两行空格明确保留，不隐藏为全仓检查通过。
