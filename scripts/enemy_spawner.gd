class_name EnemySpawner extends Node

@export var enemyTileMap : TileMapLayer
var enemiesNumber : int

# const enemyBase = preload("res://scenes/enemy.tscn")

func _ready() -> void:
	enemiesNumber = 3
	_spawnEnemiesInZone(enemyTileMap, enemiesNumber)


func _process(delta: float) -> void:
	pass

func _spawnEnemiesInZone(tilemap: TileMapLayer, n:int) -> void:
	var tiles = tilemap.get_used_cells()
	tiles.shuffle()
	for t in n:
		var enemyBase = preload("res://scenes/enemy.tscn")
		var obj = enemyBase.instantiate()
		add_child(obj)
		obj.position = tiles[t]
		
	
