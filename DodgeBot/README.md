# DodgeBot

Strafing targets spawned from Dev Lab > Targets react to your crosshair, shots and damage like a human player.

## Usage
1. Dev Lab > **MOD** > **DodgeBot** is the master switch (on by default). Off gives every target the stock strafe brain.
2. Spawn a strafing target from the Targets page. Dummy and legend bodies both work.
3. The target is taken over about 0.2 s after it spawns. The default difficulty is Ranked.
4. Change settings in the window (HOME) or in the console (`~`, lowercase):

| Command | Difficulty | Reaction | Style |
|---|---|---|---|
| `dodgebot 0` | Off | - | Stock strafe brain |
| `dodgebot 1` | Casual | 320-480 ms | Mostly plain long strafes |
| `dodgebot 2` | Ranked | 220-320 ms | Long strafes mixed with simple baits |
| `dodgebot 3` | Pro | 160-240 ms | Mostly short-short-long baits |

`dodgebot lang zh` / `en` sets the language of the on-screen messages (English by default). The settings window sends it for you.

### Speed presets
| Command | Speed | Apex equivalent |
|---|---|---|
| `dodgebot speed unarmed` | 199 u/s | Holstered |
| `dodgebot speed hipfire` | 173 u/s | Gun out |
| `dodgebot speed ads` | 130 u/s | Aiming down sights |
| `dodgebot speed 160` | Custom (50-400) | - |
| `dodgebot speed off` | Lab strafe slider | Default |

Dummies move by animation root motion, so the mod measures each strafe and calibrates toward the chosen speed. The first steps can be off. `dodgebot` prints the measured speed over the last 4 seconds.

### 360-degree respawn
| Command | Effect |
|---|---|
| `dodgebot respawn on` | Default: after a kill, the next target spawns **10-17 m** away in any direction |
| `dodgebot respawn 8 20` | Use 8-20 m (3-60 m allowed) |
| `dodgebot respawn off` | Stock behavior: spawn in front of the crosshair |

Applies only after a kill. Spawn points need standable ground, a clear line to your eyes and a height difference under about 5 m. If none is found, that respawn uses the stock position. 1 m is about 39.37 units.

## Legend bodies
On the Targets page set **strafer body = legend** and **class/legend = same as me**. Target presets do not matter, and the Lab's own target fire and accuracy settings have no effect on these bots.

| Command | Effect |
|---|---|
| `dodgebot fire on` / `off` | Shoot back (default on) / dodge only |
| `dodgebot fire` | Toggle |
| `dodgebot aim 0`-`100` | Aim skill, default 50 |
| `dodgebot ads off` / `auto` / `on` | Hipfire / auto (default) / always ADS |

- **Movement** uses real player physics at the real speed of the gun it holds, so it cannot reach unarmed 199.
- **ADS** presses the real zoom button. Auto aims down sights beyond 10 m and releases while reloading. The `ads` speed preset always aims down sights.
- **Aim** lags behind your movement and wanders: `aim 0` is 0.22 s and about 6 degrees, `aim 100` is 0.06 s and about 0.4 degrees.
- **Fire** needs line of sight and a crosshair within about 10 degrees of you, after a 0.18-0.32 s reaction. It reloads, and respects auto, semi-auto and burst guns.
- **Two guns**: swaps to the other gun when one runs dry in a fight, and reloads the empty one out of sight. Carry two guns yourself; it copies your loadout when it spawns.
- **Refill**: killing a legend bot fills your health and shield.
- **Several bots**: with more than one legend bot out the game would knock a killed one down; it is finished at once, credited to you, so the next one spawns.

## Real fight (off by default)
Legend bodies only. While it is off, the dodging logic above is unchanged.

| Command | Effect |
|---|---|
| `realfight on` / `off` | Turn on / off |
| `realfight cover off` / `hurt` / `often` | No cover / when hurt or reloading (default) / also when hit |
| `realfight slide on` / `off` | Slide jumps, on by default |

- **Cover**: looks within 5 m for a spot you cannot see, low walls included, and runs there to reload. It stays hidden until loaded, then peeks, sometimes as a fake. With nothing in range it backs off while reloading.
- **Slide-jump swing**: runs up behind cover, slide jumps out and fires in the air. It sometimes hides first to ambush you, and also swings when chasing round corners. Needs both cover and slide on.
- **Temperament**: each spawn rolls an aggression level. Health and distance then decide between pushing, holding and backing off.
- **Movement**: only keyboard directions, with uneven timing.
- **Aim**: predicts from your movement 0.14-0.3 s ago, so a sudden change of direction makes it overshoot. It fires bursts at range.
- **Air turn**: within 8 m a swap sometimes comes with a jump that curls A, W, D (or mirrored) in the air.
- **Hunting**: after about 1.2 s without sight it searches your last seen position. It does not track through walls.
- On open maps with no cover it keeps strafing. Path finding is simple obstacle avoidance.

## Strafe patterns
| Step | Length (Casual / Ranked / Pro) | Interruptible |
|---|---|---|
| Tap | 0.18-0.26 / 0.15-0.22 / 0.13-0.19 s | No |
| Medium | 0.30-0.50 / 0.25-0.42 / 0.22-0.38 s | After 0.12 s |
| Long | 0.70-1.20 / 0.60-1.10 / 0.55-1.00 s | Re-evaluated after 0.35 s |

| Pattern | Weight when reacting (Casual / Ranked / Pro) |
|---|---|
| Long | 45% / 30% / 20% |
| Short, then long the other way | 25% / 25% / 25% |
| Short, short, long | 5% / 20% / 30% |
| ADAD, then long | 15% / 15% / 15% |
| Long, then long back | 10% / 10% / 10% |
| Pause, then long | Only during a fight |

Steps are 0.85x as long at close range and up to 1.2x at long range. It reacts to a crosshair on or closing on it, bullets passing within 80 units, and damage. It never crouch-strafes. Below 35% health and shields under fire, it retreats diagonally.

## Limits
- Dummies cannot jump, slide or use cover. Legend bodies do so only in Real fight.
- A legend bot is matched to the nearest player with legend targets, so it can pick the wrong player on a shared server.
- Targets in other training modes are not taken over.
- Settings return to defaults when the game restarts. The playlist var `dodgebot_default_level` (0-3) changes the default difficulty.
