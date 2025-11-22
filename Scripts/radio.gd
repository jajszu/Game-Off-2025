extends RigidBody3D

@onready var song_player: AudioStreamPlayer3D = $SongPlayer
@onready var noise_player: AudioStreamPlayer3D = $NoisePlayer
@export var sounds: Array[AudioEnemyType]

@export var song_time: float = 20.0
@export var noise_time: float = 60.0
@export var fade_time: float = 4.0

func _ready() -> void:
	song_player.volume_db = -80.0
	noise_player.volume_db = -80.0
	play_radio_loop()

func play_radio_loop() -> void:
	while true:
		if sounds.is_empty():
			await get_tree().create_timer(1.0).timeout
			continue
			
		var sound_data = sounds.pick_random()
		song_player.stream = sound_data.audio
		song_player.play()
		print("next enemy: " + str(sound_data.enemy))
		
		# Fade in song
		var tween = create_tween()
		tween.tween_property(song_player, "volume_db", 0.0, fade_time)
		
		await get_tree().create_timer(song_time).timeout
		
		# Crossfade to noise
		noise_player.play()
		tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(song_player, "volume_db", -80.0, fade_time)
		tween.tween_property(noise_player, "volume_db", 0.0, fade_time)
		
		await get_tree().create_timer(fade_time).timeout
		song_player.stop()
		
		await get_tree().create_timer(noise_time).timeout
		
		# Fade out noise
		tween = create_tween()
		tween.tween_property(noise_player, "volume_db", -80.0, fade_time)
		
		await tween.finished
		noise_player.stop()
