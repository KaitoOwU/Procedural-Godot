class_name EnemySpawner extends Node

@onready var enemyTileMap : TileMapLayer = $"../TileMapLayer_ENEMYSPAWN"
var enemiesNumber : int

# const enemyBase = preload("res://scenes/enemy.tscn")

func _ready() -> void:
	enemiesNumber = 1
	_spawnEnemiesInZone(enemyTileMap, enemiesNumber)
	enemyTileMap.visible = false

func _spawnEnemiesInZone(tilemap: TileMapLayer, n:int) -> void:
	var enemyBase = preload("res://scenes/enemy.tscn")
	var room : Room = $".."
	var tiles = tilemap.get_used_cells()
	tiles.shuffle()
	for t in n:
		var obj = enemyBase.instantiate()
		add_child(obj)
		obj.position = Vector2(tiles[t].x, tiles[t].y) + room.global_position	
	
