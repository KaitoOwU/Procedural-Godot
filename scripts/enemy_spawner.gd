class_name EnemySpawner extends Node

@export var enemyBase : Enemy
var room : Room
var enemiesNumber : int

func _ready() -> void:
	room = $"."


func _process(delta: float) -> void:
	pass
