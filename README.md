# BeamMP Radio System Mod
# Server Side

## Overview

This mod adds a customizable radio system to BeamNG.drive multiplayer via BeamMP. Players can select radio stations in their vehicles, with 3D audio that allows nearby players to hear the music fading with distance. It includes volume control, an on-screen display for station info, a personal MP3 fallback (for non-vehicle use), and an admin command to mute radios in a radius.

Inspired by MTA:SA radio scripts, this is a from-scratch implementation tailored for BeamNG's physics and BeamMP's syncing.

## Features

- **Vehicle-Based Radio**: Select stations via ImGui UI (toggle with 'R' key). Station and volume sync across multiplayer.
- **3D Proximity Audio**: Music plays from the vehicle's position—loud inside/nearby, quieter farther away. Uses BeamNG's `Engine.Audio` for looping 3D sounds.
- **Volume Adjustment**: Slider in UI (0-100%), synced to server.
- **On-Screen Display**: Shows current station name and simulated song title in the bottom-left corner when in a vehicle.
- **Personal MP3 Fallback**: If not in a vehicle, toggle personal 2D audio playback (local only, no sync).
- **Admin Command**: `/srd` (trigger via client: `MP.TriggerServerEvent("admin:srd", "")`) mutes radios within 200m radius.
- **Predefined Stations**: 3 example stations (Rock FM, Pop Hits, Chill Vibes). Expand by adding to the `streams` table and providing .ogg/.wav files.

## Requirements

- **BeamNG.drive**: Latest version with mod support.
- **BeamMP**: Installed on server and clients.
- **Audio Files**: Place .ogg or .wav files in `mods/radio/sounds/` (e.g., `rock.ogg`). Mod won't play without them.
- **ImGui**: Required for UI (built-in to BeamNG via `ui_imgui` module).

## Installation

### Client-Side
1. Download the mod as `radio_mod.zip`.
2. Extract to your BeamNG mods folder (e.g., `Documents/BeamNG.drive/mods/`).
3. Ensure `lua/ge/extensions/radio.lua` is present.
4. Add audio files to `sounds/` inside the mod zip/folder.
5. Activate the mod in BeamNG's mod manager.

### Server-Side
1. Place the plugin in `Resources/Server/RadioPlugin/`.
2. Include `plugin.lua` and `plugin.toml`.
3. Restart the BeamMP server to load the plugin.

## Usage

1. Join a BeamMP server.
2. Enter a vehicle.
3. Press 'R' to open the Radio Controls UI.
4. Select a station and adjust volume—the changes sync to all players.
5. Nearby players will hear the audio in 3D space.
6. For admin mute: Use the trigger command in client console.

## Configuration

- **Stations**: Edit the `streams` table in `radio.lua` (client) and `plugin.lua` (server). Example:
  ```lua
  local streams = {
      {name = "Your Station", path = "mods/radio/sounds/yourfile.ogg", song = "Your Song Title"}
  }
  ```
- **Keybinds**: Change 'R' in the `onKeyUp` hook.
- **Audio Params**: Adjust min/max distance in `Engine.Audio.setMinDistance`/`setMaxDistance` for falloff tuning.

## Limitations

- **Audio Streaming**: Limited to local files (no URLs). For online streams, integrate an external tool.
- **Metadata**: Song titles are static; no dynamic tags from files.
- **Shared Vehicles**: Assumes one player per vehicle; multi-occupant logic may need expansion.
- **Performance**: 3D sounds per vehicle—test on large servers.

## Credits

- Created by Grok, built by xAI.
- Inspired by MTA:SA radio scripts.
- Uses BeamNG.drive and BeamMP APIs.

## License

MIT License. Feel free to modify and distribute.
