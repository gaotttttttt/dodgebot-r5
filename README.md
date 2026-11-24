# DodgeBot

R5Flowstate（S30）Dev Lab 的训练靶子 mod：靶子会像真人一样横移、骗招、开镜、还手。
Human-like strafing and shooting targets for the R5Flowstate S30 Dev Lab. One-click installer, in-game settings window (Chinese UI).

## [下载 / Download DodgeBot 1.1.0](../../raw/main/download/DodgeBot-1.1.0.zip)

## 安装
1. 完全退出游戏。
2. 把 zip **全部解压**，双击 `Install.bat`。
3. 进自己本地开的 Dev Lab，按 **HOME** 打开设置窗口。
4. 靶子页：扫射靶身体 = 传奇，职业/传奇 = 跟我一样，点"添加横移目标"。

升级：再运行一次新版 `Install.bat`。卸载：双击 `Uninstall.bat`。

安装器只做三件事：把两个文件夹复制到 `mods`，在 `mods.vdf` 加两行，HOME 键空闲时绑上它。被修改的文件会留 `.bak_dodgebot` 备份。脚本是纯文本，可以先打开 `install.ps1` 看。Windows 提示"未知发布者"是因为脚本没有签名。

## 功能
- **躲子弹**：休闲 / 排位 / 职业三档，有反应延迟、长横移和骗招。
- **还手**：复制你的英雄，枪法可调；10 米内腰射、10 米外开镜。
- **击杀后刷新**：10–17 米、360° 随机方向，练定位。
- **真人对战**（默认关闭）：找掩体、换弹、探头、滑铲跳拉出、推进或后撤。

## 说明
- 只用于 R5Flowstate S30 社区服务器的本地 Dev Lab，与正式版 Apex 无关。
- 设置重启游戏后回到默认值。
- 详细命令见 [DodgeBot/README.md](DodgeBot/README.md) 和 [DodgeBotUI/README.md](DodgeBotUI/README.md)。
- 非官方社区 mod，与 Respawn、EA、R5Flowstate 官方无隶属关系。

## 更新
- **1.1.0**：新增真人对战模式。
- **1.0.0**：躲子弹、传奇身体、开镜、设置窗口、一键安装。
