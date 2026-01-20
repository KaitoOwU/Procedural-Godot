class_name EnemySpawner extends Node

@export var enemyBase : PackedScene
@export var enemyTileMap : TileMapLayer
var enemiesNumber : int

func _ready() -> void:
	enemiesNumber = 3
	enemyBase = preload("res://scenes/enemy.tscn")
	_spawnEnemiesInZone(enemyTileMap, enemiesNumber)


func _process(delta: float) -> void:
	pass

func _spawnEnemiesInZone(tilemap: TileMapLayer, n:int) -> void:
	var tiles = tilemap.get_used_cells()
	tiles.shuffle()
	for t in n:
		var obj = enemyBase.instance()
		add_child(obj)
		
	
