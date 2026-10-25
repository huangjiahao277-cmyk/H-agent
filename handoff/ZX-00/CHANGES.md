# ZX-00 变更清单

## 仓库初始化

- `.gitignore`：空远端初始化基线；忽略凭据、私人数据、依赖、构建产物和本机原始证据。没有改变远端公开状态或仓库权限。
- 原始 `专属成长型Agent项目规划.md`：纳入版本控制，字节内容未修改；作为旧版规划保存，不升级为获批 ADR。

## 本任务新增

| 文件 | 用途 |
| --- | --- |
| `README.md` | 标明只有规划与 ZX-00 交付，提供文档入口 |
| `docs/INVENTORY.md` | 实际目录、模块四类库存、接口／数据库／依赖现状 |
| `docs/GAP_ANALYSIS.md` | 权威输入缺失、规划差异、严重级别和门槛 |
| `docs/BOOTSTRAP.md` | 可复跑盘点命令、启动阻断、后续需要的输入 |
| `handoff/ZX-00/TASK.md` | 任务、负责人、分支、版本、范围、交接结论 |
| `handoff/ZX-00/CHANGES.md` | 本文件，变更与范围 |
| `handoff/ZX-00/TEST_EVIDENCE.md` | 实测环境、命令、stdout/stderr 摘要、数量与 AC 限制 |
| `handoff/ZX-00/KNOWN_ISSUES.md` | 未解决问题、阻断项和验收状态 |
| `handoff/ZX-00/review_request.md` | 给 Claude 的具体复核事项 |
| `handoff/ZX-00/evidence/initial-files.json` | 初始唯一文件的相对路径、大小、SHA-256 |
| `handoff/ZX-00/evidence/collect.ps1` | 只读文件／环境检查与原始 stdout/stderr 采集脚本 |
| `handoff/ZX-00/evidence/verify.ps1` | 交付完整性、原文哈希、脚本语法和有限敏感值检查 |
| `handoff/ZX-00/evidence/SUMMARY.md` | 便于仓库分发的脱敏真实证据摘要 |
| `handoff/ZX-00/evidence/verification.json` | 最后一次交付完整性检查结果；不含本机绝对路径 |

本机原始 `evidence/baseline/*`、早期 `evidence/pre-bootstrap/*`（早期采集器退出码不完整，不作为结论依据）、网络日志、API 中间元数据、本次结束 SHA 收据和后续复跑日志均保留本地并被忽略，不进 Git。权威证据为修正采集器后得到的 baseline。

## 不在本次范围

未创建 FastAPI／Expo 演示代码、数据库模型／迁移、OpenAPI／事件 Schema、ProviderAdapter、认证、记忆门禁、私有表情、PAD/TTS 或部署流水线；未重构、启用 R2、调用供应商、构建 APK、连接真机、演练服务器备份恢复或发布生产。原始文件内容保持不变。
