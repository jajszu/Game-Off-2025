extends RigidBody3D

@onready var song_player: AudioStreamPlayer3D = $SongPlayer
@onready var noise_player: AudioStreamPlayer3D = $NoisePlayer
@export var sounds: Array[AudioEnemyType]
