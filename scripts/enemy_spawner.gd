class_name EntitySpawner extends Node

@onready var enemyTileMap : TileMapLayer = $"../TileMapLayer_ENEMYSPAWN"
var enemiesNumber : int
var keyNumber : int
var heartNumber : int
var chestNumber : int

func _ready() -> void:
	enemiesNumber = randi_range(1, 2)
	keyNumber = randi_range(0, 1)
	heartNumber = randi_range(0, 2)
	chestNumber = randi_range(0, 2)
	_spawnEntitiesInZone(enemyTileMap)
	enemyTileMap.visible = false

func _spawnEntitiesInZone(tilemap: TileMapLayer) -> void:
	var enemyBase = preload("res://scenes/enemy.tscn")
	var room : Room = $".."
	var tiles = tilemap.get_used_cells()
	var n = enemiesNumber + keyNumber + heartNumber + chestNumber
	tiles.shuffle()
	for t in enemiesNumber:
		var obj = enemyBase.instantiate()
		add_child(obj)
		obj.position = Vector2(tiles[t].x, tiles[t].y) + room.global_position	
	
