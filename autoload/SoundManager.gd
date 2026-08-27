extends Node
## SoundManager (Singleton)
## Centralizes all audio playback. Designed so it never crashes if you haven't
## dropped audio files in yet -- drop your files into res://assets/audio/
## using the filenames below and everything wires up automatically.

var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
const SFX_POOL_SIZE := 6

const MUSIC_PATH := "res://assets/audio/music_loop.ogg"
const SFX_PATHS := {
	"jump": "res://assets/audio/sfx_jump.ogg",
	"coin": "res://assets/audio/sfx_coin.ogg",
	"crash": "res://assets/audio/sfx_crash.ogg",
	"level_complete": "res://assets/audio/sfx_level_complete.ogg",
	"button": "res://assets/audio/sfx_button.ogg",
	"ramp": "res://assets/audio/sfx_ramp.ogg",
}

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)

	for i in range(SFX_POOL_SIZE):
		var p := AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		sfx_players.append(p)

	apply_volumes()

func play_music() -> void:
	if not ResourceLoader.exists(MUSIC_PATH):
		return
	if music_player.stream == null:
		music_player.stream = load(MUSIC_PATH)
	if not music_player.playing:
		music_player.play()

func stop_music() -> void:
	music_player.stop()

func play_sfx(sfx_name: String) -> void:
	if not SFX_PATHS.has(sfx_name):
		return
	var path: String = SFX_PATHS[sfx_name]
	if not ResourceLoader.exists(path):
		return
	for p in sfx_players:
		if not p.playing:
			p.stream = load(path)
			p.play()
			return
	# All busy: steal the first one
	sfx_players[0].stream = load(path)
	sfx_players[0].play()

func apply_volumes() -> void:
	var music_vol: float = SaveManager.get_setting("music_volume")
	var sfx_vol: float = SaveManager.get_setting("sfx_volume")
	_set_bus_volume("Music", music_vol)
	_set_bus_volume("SFX", sfx_vol)

func _set_bus_volume(bus_name: String, linear: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		idx = 0 # fall back to Master if custom buses weren't created in the audio bus layout
	AudioServer.set_bus_volume_db(idx, linear_to_db(clamp(linear, 0.0001, 1.0)))
	AudioServer.set_bus_mute(idx, linear <= 0.0001)

func set_music_volume(v: float) -> void:
	SaveManager.set_setting("music_volume", v)
	apply_volumes()

func set_sfx_volume(v: float) -> void:
	SaveManager.set_setting("sfx_volume", v)
	apply_volumes()
