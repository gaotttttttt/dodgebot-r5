# DodgeBot UI

A settings window for DodgeBot. **DodgeBot must also be enabled.** Each change sends the matching console command; this mod does not modify DodgeBot's code.

## Open it
- Press **HOME** (bound by the installer if the key was free), or
- Dev Lab > **MOD** > turn on **DodgeBot UI** (it works as a button and springs back to off), or
- type `dodgebotui` in the console.

To bind it yourself: `bind_US_standard "HOME" "dodgebotui" 0`. Press **ESC** or click Close to exit.

## Settings
| Section | Setting | Command |
|---|---|---|
| Dodging and speed | Difficulty | `dodgebot 0`-`3` |
| | Speed preset | `dodgebot speed off/unarmed/hipfire/ads` |
| | Custom speed (50-400) | `dodgebot speed <number>` |
| Respawn after a kill | 360 deg respawn | `dodgebot respawn on/off` |
| | Nearest / Farthest (3-60 m) | `dodgebot respawn <min> <max>` |
| Legend bots | Shoot back | `dodgebot fire on/off` |
| | ADS | `dodgebot ads off/auto/on` |
| | Aim (0-100) | `dodgebot aim <number>` |
| Real fight | On/off, cover, slide jump | `realfight on/off`, `realfight cover ...`, `realfight slide on/off` |

Values not in use are greyed out. The footer shows the last command sent. Reset all restores the defaults.

## How long settings last
- They survive map changes: changes you made in the window are resent about 3 s after loading in.
- They reset when the game restarts.
- The window does not see commands typed in the console, and its values overwrite them on the next load.
