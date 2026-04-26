extends Node2D

var music_bus := AudioServer.get_bus_index("Music")
var lowpass_effect: AudioEffectLowPassFilter

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var ui_sfx_player: AudioStreamPlayer = $UISfxPlayer
@onready var death_sfx_player: AudioStreamPlayer = $DeathSfxPlayer
@onready var ambient_player: AudioStreamPlayer = $AmbientPlayer
@onready var evolution_player: AudioStreamPlayer = $EvolutionPlayer
@onready var kill_player: AudioStreamPlayer = $KillPlayer

@export var music_track: AudioStream
@export var ambient_track: AudioStream
@export var ui_click_sound: AudioStream
@export var death_sound: AudioStream
@export var evolution_sound: AudioStream
@export var kill_sound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	music_player.stream = music_track
	ui_sfx_player.stream = ui_click_sound
	death_sfx_player.stream = death_sound
	ambient_player.stream = ambient_track
	evolution_player.stream = evolution_sound
	kill_player.stream = kill_sound
	
	music_player.volume_db = -3
	ambient_player.volume_db = -15
	evolution_player.volume_db = -14
	kill_player.volume_db = -14
	lowpass_effect = AudioServer.get_bus_effect(music_bus, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func play_game_music() -> void:
	if !music_player.playing:
		music_player.play()
	play_ambient()

func play_ambient() -> void:
	if !ambient_player.playing:
		ambient_player.play()

func stop_ambient() -> void:
	ambient_player.stop()

func stop_game_music() -> void:
	music_player.stop()
	stop_ambient()
	
func play_ui_click() -> void:
	if ui_click_sound != null:
		ui_sfx_player.play()

func play_death() -> void:
	if death_sound != null:
		death_sfx_player.play()
		
func play_kill() -> void:
	if kill_sound != null:
		kill_player.play()

func play_evolution() -> void:
	if evolution_sound != null:
		evolution_player.play()

func play_music() -> void:
	if music_track != null and !music_player.playing:
		music_player.play()

func stop_music() -> void:
	music_player.stop()
	
func set_music_muffled(enabled: bool) -> void:
	AudioServer.set_bus_effect_enabled(music_bus, 0, enabled)

func set_music_paused_state(paused: bool) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	if paused:
		AudioServer.set_bus_effect_enabled(music_bus, 0, true)

		tween.parallel().tween_property(
			music_player,
			"volume_db",
			-10.0,
			0.4
		)

		tween.parallel().tween_property(
			lowpass_effect,
			"cutoff_hz",
			900.0,
			0.4
		)

	else:
		tween.parallel().tween_property(
			music_player,
			"volume_db",
			0.0,
			0.4
		)

		tween.parallel().tween_property(
			lowpass_effect,
			"cutoff_hz",
			20500.0,
			0.4
		)

		await tween.finished
		AudioServer.set_bus_effect_enabled(music_bus, 0, false)
