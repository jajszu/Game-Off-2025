extends Item

@export var spawns: Array[Node3D]
@onready var song_player: AudioStreamPlayer3D = $SongPlayer
@onready var noise_player: AudioStreamPlayer3D = $NoisePlayer
@export var sounds: Array[AudioEnemyType]
@export var songs: Array[AudioStream]

@export_range(-80, 0) var noise_volume: float = 0.0
@export var song_time: float = 40.0
@export var instructions_time = 20.0
@export var noise_time: float = 60.0
@export var fade_time: float = 2.0

func _ready() -> void:
	song_player.volume_db = -80.0
	noise_player.volume_db = -80.0
	play_radio_loop()

func play_radio_loop() -> void:
	while true:
		if sounds.is_empty():
			await get_tree().create_timer(1.0).timeout
			continue
			
		#pick neutral song
		var tween := create_tween()
		var song = songs.pick_random()
		song_player.stream = song
		song_player.play()
		
		#fade in song 
		tween.tween_property(song_player, "volume_db", 0.0, fade_time)
		
		await get_tree().create_timer(song_time).timeout
		
		#tween to noise before instructions
		noise_player.play()
		tween_song_to_noise(tween)
		
		await get_tree().create_timer(fade_time * 2).timeout
		
		#pick next enemy
		var sound_data = sounds.pick_random()
		song_player.stream = sound_data.audio
		
		#choose spawn point (higher distance)
		
		var max_dist := 0.0
		var chosen_spawn: Vector3 = Vector3.ZERO
		var player_pos = Globals.current_map.player.global_position
		for s in spawns:
			var dist := s.global_position.distance_to(player_pos)
			if dist > max_dist:
				max_dist = dist
				chosen_spawn = s.global_position
		
		var enemy = sound_data.enemy.instantiate()
		Globals.current_map.add_child(enemy)
		enemy.global_position = chosen_spawn
			
		
		song_player.play()
		tween_noise_to_song(tween)
		await get_tree().create_timer(instructions_time).timeout
		
		# Crossfade to noise
		noise_player.play()
		tween_song_to_noise(tween)
		#TODO: spawn enemy
		await get_tree().create_timer(noise_time).timeout
		
		# Fade out noise
		tween = create_tween()
		tween.tween_property(noise_player, "volume_db", -80.0, fade_time)
		
		await tween.finished

func tween_noise_to_song(tween: Tween):
		tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(noise_player, "volume_db", -80.0, fade_time)
		tween.tween_property(song_player, "volume_db", 0.0, fade_time)

func tween_song_to_noise(tween: Tween):
		tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(song_player, "volume_db", -80.0, fade_time)
		tween.tween_property(noise_player, "volume_db", noise_volume, fade_time)
