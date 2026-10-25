# ZX-00 → Claude 复核请求

接收模型：Claude。请求的是库存核实与 ZX-01 输入准备；不是生产发布批准。本文件未自动发送到其他聊天。

## 请先阅读

`README.md` → `docs/INVENTORY.md` → `docs/GAP_ANALYSIS.md` → `docs/BOOTSTRAP.md` → 本目录五件套及 `evidence/SUMMARY.md`。原始唯一输入为根目录 `专属成长型Agent项目规划.md`；SHA-256 见 `evidence/initial-files.json`。

任务分支：`feat/ZX-00-inventory`。起始 SHA：`c676fafa7e8029dd0b407af5298d22a65e124ff3`。结束 SHA 在 PR head、PR 描述及本机 `evidence/local-delivery.json`。main 初始化时仅有 `.gitignore`；没有既有实现。

## 具体复核问题

1. 请确认“只有规划、无代码”的库存与远端基线一致；不要把新建 README、脚本或环境版本视为已有产品。
2. 请取得并核对 ZX-DEV-RACI-001 v1.0、《统一项目指令》、获批 ADR、正式 AC 明细及分工；这些正文当前缺失。
3. 请裁定旧版规划与本轮移动端、五角色、表情、PAD/TTS 的范围差异，以及“明确事实”与未经核验原话的语义差异；保留决策记录。
4. 接口差异当前无法计算：没有 OpenAPI、事件 Schema、TypeScript 契约、路由、请求响应或错误码。请在 ZX-01 提供批准版本与 SHA，勿把“缺失”写成“无差异”。
5. 数据库现状：没有 ORM、SQL、迁移、约束、revision 或本地数据库文件；服务器未知。请在设计时明确核心结构、迁移／回滚和 Claim/Evidence／来源／纠错关系，不要假设已有表。ZX-11B 等待获批 ZX-11A。
6. 请评估 INV 交付核验，单独保留正式 AC 未测试状态。原始日志本机保留，仓库只有脱敏摘要；如需独立证据，通过所有者授权私下取阅或复跑。

待补输入：上述权威正文与批准记录、冻结契约；后续运行所需的受控 Linux 环境、版本要求及验收设备条件。无需在 Git／本次交接中提供 Key、Token、个人对话或签名密钥。

独立 DeepSeek QA、所有者签收尚未发生。收到本交接不意味着 G0–G4 放行。Codex 本轮未执行 ZX-02 及之后任务。
