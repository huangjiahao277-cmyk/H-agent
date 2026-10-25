# ZX-00 脱敏证据摘要

检查日期：2026-10-25（Asia/Shanghai）。这是基于实际命令输出整理的摘要，不是原始日志或独立 QA。原始日志保留本机 `baseline/`，不公开本机路径与元数据中间文件。复现脚本为 collect.ps1；参数与结果映射见 TEST_EVIDENCE.md。

| 检查 | 实际结果 |
| --- | --- |
| 初始文件数量 | 1；仅规划 Markdown；17,883 字节 |
| 原始文件 SHA-256 | `62B96653D95D9CD6319583351BFBA42FE2F28A1076810ED3F3A18177E9CE8D27` |
| 初始 Git 四条命令 | 全部 128；`fatal: not a git repository (or any of the parent directories): .git` |
| 约定工程入口 | 21 个检查全部不存在；后续新增文档与 Git 不属于原始发现 |
| 应用代码／配置／数据库／APK 搜索 | `matching_file_count: 0`，`files: []` |
| PowerShell / OS | 7.6.5 / Windows 10.0.26200，X64 |
| Git / Node / npm | 2.55.0.windows.3 / v24.18.0 / 11.16.0，退出 0 |
| Python | 退出 9009；`Python was not found`，Windows 商店别名 |
| Docker / psql | PATH 未找到命令；未启动进程，退出码不适用 |
| adb / Java | 1.0.41（Platform Tools 37.0.1-15733141）/ OpenJDK 17.0.20.1，退出 0 |
| 库存命令统计 | 17 项；15 个进程；10 项退出 0；5 项非零；2 项未启动 |
| 应用测试／类型／构建 | 执行 0，失败未测量；未测试／待验收 |
| 远端首次检查 | GitHub API contents 返回 404 `This repository is empty.`；branches 返回 `[]`；仓库公开 |
| 仓库初始化 | 仅 `.gitignore`；main SHA `c676fafa7e8029dd0b407af5298d22a65e124ff3` |
| 本机 Git HTTPS | fetch 退出 128：`Operation too slow. Less than 1 bytes/sec transferred the last 10 seconds` |
| 同步方式 | GitHub 连接器；本地基线 tree／commit 哈希与远端完全一致后导入；不宣称 CLI push 成功 |

初始扫描快照见 initial-files.json；交付文档完整性与有限安全检查见 verification.json。原始规划保持不变。未执行第三方模型、生产服务、设备测试或备份恢复。

交付完整性：`verify.ps1` 实测 8 项、失败 0，应用测试仍为 NOT_RUN。第一次暂存区空白检查退出 2，原因与修复／保留项见 TEST_EVIDENCE.md；生成 JSON 改为 LF，原始 Markdown 的两空格换行保持不变。
