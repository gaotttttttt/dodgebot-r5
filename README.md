# DodgeBot

A training mod for the R5Flowstate (S30) Dev Lab. Targets strafe, bait, aim down sights and shoot back like human players. Includes a one-click installer and an in-game settings window.

## [Download DodgeBot 1.3.2](../../raw/main/download/DodgeBot.zip)

## Install
1. Quit the game completely.
2. **Extract the whole zip** and double-click `Install.bat`.
3. Host a local Dev Lab and press **HOME** to open the settings window.
4. Under **Targets and practice** at the top of the window, click `>` to add a legend target (up to 6). Or use the Lab Targets page: strafer body = legend, class/legend = same as me.

To update, run the new `Install.bat`. To remove, run `Uninstall.bat`.

The installer copies two folders into `mods`, adds two lines to `mods.vdf`, and binds HOME if it is free. Edited files get a `.bak_dodgebot` backup. The scripts are plain text, so you can read `install.ps1` first. Windows may show "unknown publisher" because the scripts are not signed.

## Features
- **Dodging**: Casual, Ranked and Pro, with reaction delay, long strafes and baits.
- **Legend bots that shoot back**: copy your legend, adjustable aim, hipfire within 10 m and ADS beyond.
- **Several targets**: add up to 6 legend targets from the settings window.
- **God mode switch**: a reliable on/off for Lab god mode, kept across map loads.
- **360-degree respawn**: the next target appears 10-17 m away in any direction.
- **Real fight** (off by default): cover, reloading, peeking, slide-jump swings, pushing and backing off.

## Notes
- For local R5Flowstate S30 Dev Lab sessions only. Not for official Apex Legends.
- Settings return to defaults when the game restarts. The language choice is kept.
- Chinese / English: the button at the top right of the settings window. The first time it follows the game language.
- Commands: [DodgeBot/README.md](DodgeBot/README.md) and [DodgeBotUI/README.md](DodgeBotUI/README.md).
- Unofficial community mod, not affiliated with Respawn, EA or R5Flowstate.

## Changelog
- **1.3.2**: A newly added target (not one respawning after a kill) that lands beyond the respawn range is moved next to you as well.
- **1.3.1**: God mode switch in the settings window: a plain on/off that is set again after every map load.
- **1.3.0**: Spawn up to 6 legend targets from the settings window. With several legend bots out, a killed one dies instead of being knocked down, and the next one spawns.
- **1.2.0**: Chinese / English switch in the settings window. The choice is remembered and also sets the language of on-screen messages.
- **1.1.5**: Real fight: better cover and reloading, shooting and swapping during slide jumps, air turns on a swap. Gun swapping in normal mode. A kill refills your health and shield.
- **1.1.4**: Real fight bots use both of your guns: they swap when one runs dry.
- **1.1.3**: Real fight bots no longer hold fire up close or stall after a reload.
- **1.1.2**: Legend bots now spawn at full health instead of copying yours.
- **1.1.1**: English text throughout.
- **1.1.0**: Real fight mode.
- **1.0.0**: Dodging, legend bodies, ADS, settings window, one-click installer.
