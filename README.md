# BeamMP Radio System Mod

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
