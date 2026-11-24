# DodgeBot UI（DodgeBot 设置窗口）

给 DodgeBot 加一个图形设置窗口。**需要 DodgeBot mod 同时开着**。这个 mod 不改 DodgeBot 的任何代码：窗口里每改一项，就替你发一条对应的 `dodgebot ...` 控制台命令。

## 打开
**方法一**：Dev Lab → **MOD** 页 → 把 **DodgeBot UI** 拨到开启，窗口就会弹出（这一行相当于按钮，之后会自动弹回关闭）。

**方法二**：控制台（`~`）输入：

```
dodgebotui
```

绑到 HOME 键：在控制台输入 `bind_US_standard "HOME" "dodgebotui" 0`（只需一次）。按 **ESC** 或点左下角"关闭"退出。

## 窗口里有什么
| 分区 | 设置 | 对应命令 |
|---|---|---|
| 躲避与移速 | 难度：关闭 / 休闲 / 排位 / 职业 | `dodgebot 0`–`3` |
| | 移速挡位：跟随滑块 / 空手 199 / 腰射 173 / 开镜 130 | `dodgebot speed off/unarmed/hipfire/ads` |
| | 自定义移速（50–400，点 `<` `>` 就切到自定义） | `dodgebot speed <数值>` |
| 击杀后刷新 | 360° 随机刷新：开 / 关 | `dodgebot respawn on/off` |
| | 最近 / 最远距离（3–60 米） | `dodgebot respawn <最近> <最远>` |
| 传奇靶子 | 还手：开 / 关 | `dodgebot fire on/off` |
| | 开镜：腰射 / 自动 / 一直开镜 | `dodgebot ads off/auto/on` |
| | 枪法（0–100） | `dodgebot aim <数值>` |
| 真人对战 | 开关、掩体、滑铲跳 | `realfight on/off`、`realfight cover ...`、`realfight slide on/off` |

- 当前没在用的数值会变灰。例如移速挡位不是"自定义"时，自定义移速是灰的；还手关掉时，枪法是灰的。
- 底部会显示最后发送的命令。右下角"恢复默认"会把所有设置改回 DodgeBot 的默认值。
- 发送命令时 DodgeBot 也会照常在屏幕上弹出状态提示。

## 设置会保留多久
- **换地图、重新进 Lab 会保留**。服务器每张地图都会把 DodgeBot 设置重置成默认值，所以进图约 3 秒后，窗口会把你这次改过的设置自动重发一遍（只有你在窗口里改过才会重发）。
- **重启游戏后回到默认值**。
- 直接在控制台输入 `dodgebot ...` 改的设置，窗口不会知道，下次进图时会被窗口里的值覆盖。

## Lab > MOD 页
**DodgeBot UI** 那一行是打开窗口的按钮，平时显示"关闭"是正常的，不影响 DodgeBot 本身。

## 文件
- `resource/ui/menus/trainer_dodgebotui/trainer_dodgebotui__settings.menu`：窗口布局，样式照着游戏自带的 1v1 设置窗口做。
- `scripts/vscripts/trainer_dodgebotui/ui_dodgebotui.gnut`：窗口逻辑（界面虚拟机）。
- `cl_dodgebotui.gnut` / `sv_dodgebotui.gnut`：`dodgebotui` 命令，以及进图后的自动重发。
