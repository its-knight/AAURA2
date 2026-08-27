# Aura

A snowboarding endless-adventure runner inspired by Alto's Adventure, built
in **Godot 4.2+**.

## Opening the project

1. Install Godot 4.2 or later (godotengine.org — the standard, non-.NET build is fine, GDScript only).
2. Godot → Import → select this folder's `project.godot`.
3. Press **F5** (or the Play button) to run. The default main scene is
   `scenes/Main.tscn`, which forwards straight to the main menu.

## Controls

- **Tap / hold anywhere on screen (or left mouse button in the editor):**
  tap = jump (works again in mid-air for a double jump); hold = boost.
- **Esc** (mapped to the `pause` input action): pause during a run.

## What's implemented

- Auto-run player with jump, double jump, hold-to-boost, and a glowing trail
- 5 levels, difficulty (length/obstacles/speed) defined in `autoload/LevelManager.gd`
- Rocks (3 sizes), golden ramps with spark particles, coins (50/level),
  swaying pine trees, drifting clouds, parallax mountains, sine-wave hills
- Scoring: coins (10 pts), distance/speed bonus, jump combo bonus
- Day → night sky lerp tied to level progress
- Main Menu, Level Select (locked/unlocked + stars), Settings (music/sfx
  volume, jump sensitivity, theme flag), High Scores, Pause, Game Over,
  Level Complete (animated star rating) — all styled via one shared
  glassmorphism helper (`scripts/UITheme.gd`), no external theme assets needed
- Persistent save data (`user://aura_save.cfg`): unlocked levels, per-level
  stars and high score, and all settings
- Object pooling (`scripts/ObjectPool.gd`) for obstacles, coins, ramps, trees
  and clouds — no `instantiate()`/`queue_free()` calls happen during a run,
  which is what actually keeps this smooth on low-end Android hardware
- Singleton managers: `GameManager`, `SoundManager`, `LevelManager`, `SaveManager`

## What you need to add yourself

- **Art**: everything currently renders as flat-colored polygons (player,
  rocks, trees, coins, mountains) so the project runs with zero external
  assets. Swap in real sprites by replacing the `Polygon2D`/`Line2D` nodes
  in the relevant `.tscn` files with `Sprite2D`/`AnimatedSprite2D` nodes.
- **Audio**: drop `.ogg` files into `assets/audio/` using the exact names
  listed in `assets/audio/README.txt`. `SoundManager` checks whether each
  file exists before playing, so nothing breaks if you leave some out.
- **Audio bus layout**: the code looks for buses named `Music` and `SFX`
  (Project → Project Settings → Audio → Buses) — add those two buses (routed
  to Master) so the volume sliders in Settings actually do something;
  otherwise it safely falls back to controlling Master.

## Exporting the Android APK

This sandbox has no Android SDK / Godot export templates, so the actual
`.apk` has to be built on your machine:

1. Godot → Editor → Manage Export Templates → download/install templates
   matching your Godot version.
2. Install the Android SDK (Android Studio's SDK Manager is the easiest
   route) and point Godot at it: Editor → Editor Settings → Export → Android
   → set Android SDK Path, and generate/select a debug keystore.
3. Project → Export → Add... → Android.
4. In the Android export preset:
   - **Screen → Orientation**: `landscape` (project.godot already forces
     this at the engine level too)
   - **Min SDK**: 21 (Android 5.0 Lollipop, matches the spec)
   - **Package → Unique Name**: e.g. `com.yourstudio.aura`
5. Click **Export Project**, choose a `.apk` path, and Godot builds it.

Because everything here is primitive-shape placeholder art with no audio
files bundled, the resulting APK will be well under the 50MB target — real
sprite/audio assets will be the main thing that grows it, so keep an eye on
texture sizes once you add art.

## Project layout

```
Aura/
├── project.godot
├── autoload/        # Singletons: SaveManager, SoundManager, LevelManager, GameManager
├── scripts/         # All gameplay + UI logic
├── scenes/          # All .tscn scenes/prefabs
└── assets/
    ├── audio/       # put your .ogg files here (see README.txt inside)
    └── sprites/     # put your art here and wire it into the .tscn files
```
