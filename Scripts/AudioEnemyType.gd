class_name AudioEnemyType
extends Resource
enum EnemyType{
	FLOOR_IS_LAVA,
	TURN_OFF_LIGHT,
	TURN_ON_LIGHT,
	DONT_LOOK,
	LOOK,
	HIDE
}
@export var audio: AudioStream
@export var enemy: EnemyType
