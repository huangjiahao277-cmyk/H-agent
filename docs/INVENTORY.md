# ZX-00 库存清单

检查日期：2026-10-25（Asia/Shanghai）。负责人：Codex。分支：`feat/ZX-00-inventory`。

## 检查边界与版本

实际本地根目录记录于本机证据 `handoff/ZX-00/evidence/baseline/01-environment.stdout.txt`；此处不公开本机绝对路径。首次检查仅有一个文件，且当前目录及父级不是 Git 仓库。未访问其他项目、私人 Linux 服务器或手机。

唯一原始文件：`专属成长型Agent项目规划.md`，17,883 字节，v0.1，日期 2026-10-25。原文声明处于需求与实施规划阶段，尚未开发或部署。初始 SHA-256：`62B96653D95D9CD6319583351BFBA42FE2F28A1076810ED3F3A18177E9CE8D27`，见 `handoff/ZX-00/evidence/initial-files.json`。原文未修改。

用户随后确认“本地就这个文件”，并授权使用 GitHub 仓库 `huangjiahao277-cmyk/H-agent`。GitHub API 检查发现远端为公开空仓库：目录接口 404，明确返回 `This repository is empty.`，分支列表 `[]`。随后仅以 `.gitignore` 初始化 `main`，任务起始 SHA 为 `c676fafa7e8029dd0b407af5298d22a65e124ff3`。初次检查的 Git SHA 不可用；这个新提交不代表此前存在代码。

结束 SHA 通过本任务 PR 的 head 和本地 `handoff/ZX-00/evidence/local-delivery.json` 定位；不在提交内容中伪造自引用哈希。

## 原始目录

```text
<workspace>/
└── 专属成长型Agent项目规划.md
```

新增交付：`.gitignore`、`README.md`、`docs/`、`handoff/ZX-00/`。这些是此次文档与证据，不是发现的现有应用模块。

## 模块分类

“完全缺失”仅指已检查的本地输入和空远端，没有推断其他服务器上的资产不存在。

| 模块 | 分类 | 实际证据及限制 |
| --- | --- | --- |
| 项目规划 | 文档存在；不属于运行模块 | 唯一原始 Markdown 文件及 SHA-256 |
| 已实现且可运行的应用模块 | 无 | 未发现应用源码、清单、入口或运行产物 |
| 演示 Mock / FastAPI 演示后端 | 无 | 未发现 Python 文件或演示 API；不能归类为生产后端 |
| 源码存在但未运行的应用模块 | 无 | 代码及配置搜索结果为 0；规划文字不计源码 |
| FastAPI 正式 API / 认证 / 会话吊销 / 授权 | 完全缺失 | 无 `backend`、`apps/api`、Python 依赖或入口 |
| MiMo / DeepSeek 模型适配、显式选择、费用和超时 | 完全缺失 | 无 ProviderAdapter 或模型调用代码；未读凭据或调用供应商 |
| 五角色、共享事实和权限、人格状态同步 | 完全缺失 | 只有规划中的人格设计，无实现 |
| 原始档案、Claim/Evidence、来源、纠错、记忆写入门禁 | 完全缺失 | 只有规划；无 API、持久化模型或回归用例 |
| 私有表情包上传、标签、收藏、检索、发送、幂等 | 完全缺失 | 无客户端、存储、鉴权下载或服务端校验 |
| PAD 状态、确定性衰减、事件审计 | 完全缺失 | 无算法、状态结构或审计事件实现 |
| 本地 TTS、停止、自动朗读控制 | 完全缺失 | 无移动端或语音代码 |
| Android 优先 React Native/Expo 与 iOS 预留 | 完全缺失 | 无 `apps/mobile` 或旧 Expo 工程，无 JS/TS、`app.json`、`eas.json` |
| PostgreSQL / Alembic | 完全缺失（仓库资产） | 无模型、SQL、迁移配置或迁移版本目录；实际服务器数据库未知 |
| 测试 / 类型检查 / 构建 / CI | 完全缺失 | 无测试文件、依赖清单、锁文件、脚本或流水线 |
| 部署、HTTPS、备份、恢复、审计、安全运维 | 完全缺失 | 无 Docker/Compose、环境示例或运维脚本；未连接私有服务器 |
| Release APK、签名、SHA-256、真机证据 | 完全缺失 | 无 APK 或构建工程；adb 版本可用不等于已连接真机 |
| 在线素材检索 R2 | 未实现／范围外 | 本轮没有申请或启用 |

## 接口、数据库和依赖

- 原始 `README.md`、`contracts/openapi.yaml`、事件 Schema、已批准 ADR 均缺失。没有可比较的接口版本、路径、字段、状态码或 TypeScript 类型；差异不是“0”，而是无法计算。
- 没有 ORM、表结构、核心字段、约束、Alembic revision、数据库转储或本地数据库文件。当前数据库版本、数据量、迁移 head、备份及恢复能力均未知；没有访问服务器作推断。
- 没有 `package.json`、锁文件、`pyproject.toml`、`requirements*.txt`。依赖版本、安装命令、启动命令、测试命令及构建命令均未定义；未安装依赖来创造通过结果。
- ZX-DEV-RACI-001 v1.0、《统一项目指令》和正式 AC 清单缺失；本轮用户消息提供部分规则，不等同于完整权威文件。

## 实测环境与门槛

本机：Windows `10.0.26200` / X64，PowerShell `7.6.5`；Git `2.55.0.windows.3`；Node `24.18.0`；npm `11.16.0`；Java `17.0.20.1`；adb `1.0.41` / Platform Tools `37.0.1-15733141`。`python --version` 返回 9009，指向 Windows 商店别名；Docker、psql 在 PATH 中未找到。未据此断言整台机器没有其他 Python 或数据库安装。

应用测试、类型检查和构建均未测试。G0 被权威输入和契约缺失阻断；G1–G4 均未测试／待验收。没有任何生产能力或放行通过声明。
