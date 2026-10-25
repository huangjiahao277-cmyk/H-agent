# ZX-00 复查与启动说明

当前没有可以启动的应用。不要把 `uvicorn`、`npm start`、`expo start`、`pytest` 或 Alembic 命令写成已验证的启动／测试命令：仓库没有对应入口和清单。

## 本次可以复现的命令

在本仓库根目录的 PowerShell 7 中运行：

```powershell
git status --short --branch
git rev-parse HEAD
git branch --show-current
rg --files --hidden -g '!.git' -g '!node_modules' -g '!handoff' -g '!docs'
& './handoff/ZX-00/evidence/collect.ps1'
& './handoff/ZX-00/evidence/verify.ps1'
```

`collect.ps1` 默认把新证据写入 `evidence/runs/<时间戳>/`，不会覆盖初次 `baseline/`。它只检查文件和 CLI 版本，不安装依赖、不启动服务、不读取环境变量／密钥、不访问供应商、不初始化 Git。复跑时 Git 和 README 状态会与初次检查不同，必须按运行时间区分结果。`verify.ps1` 只校验 ZX-00 文档、脚本语法、规划原文完整性和有限的敏感值模式，不是业务测试。

完整原始证据仅在检查机器：`handoff/ZX-00/evidence/baseline/results.json` 及配套 `*.stdout.txt`、`*.stderr.txt`。公开版摘要是 `handoff/ZX-00/evidence/SUMMARY.md`。PR 的 head 和本机 `evidence/local-delivery.json` 给出交付结束 SHA；初次起点记录于 TASK.md。原始日志不随 Git 分发；接收者需要原始证据时，经所有者授权通过私有渠道取阅，或者自行复跑检查。

## 后续首次启动前的必要输入

1. 提供 ZX-DEV-RACI-001 v1.0、《统一项目指令》、正式 AC 明细与批准 ADR；由 Claude 澄清旧规划和本轮范围差异。
2. 完成 ZX-01 冻结：OpenAPI、事件 Schema、核心数据结构、版本和批准 SHA。不要创建空契约让缺失检查看似通过。
3. 在后续任务提供真实 FastAPI／Expo 源码、锁定依赖、环境变量名称示例、迁移和测试入口。届时从真实清单提取安装、启动、测试和构建命令。
4. 确定受控 Linux 开发／测试环境、数据库实例及迁移策略；模型凭据仅放服务器安全存储，不经 Git 或测试日志传递。当前没有可运行配置，因此本轮没有凭空添加 `.env.example` 或连接串。
5. 手机端与签名 Release APK、真机、备份恢复独立验收；不得以工具版本、Mock、Expo Go 或模拟器结果替代。

不在本轮安装依赖、开放端口、创建数据库、上线服务、外发私人数据或生成 App。仓库初始化是所有者本轮追加授权，未改变 ZX-00 的业务范围。
