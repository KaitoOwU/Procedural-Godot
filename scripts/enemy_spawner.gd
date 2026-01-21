class_name EntitySpawner extends Node

@onready var enemyTileMap : TileMapLayer = $"../TileMapLayer_ENEMYSPAWN"
var enemiesNumber : int
var collectiblesNumber : int


func _ready() -> void:
	await get_tree().create_timer(0.2).timeout # wait for other generations
	enemiesNumber = randi_range(1, 2)
	collectiblesNumber = randi_range(0, 3)
	_spawnEntitiesInZone(enemyTileMap)
	enemyTileMap.visible = false

func _spawnEntitiesInZone(tilemap: TileMapLayer) -> void:
	var room : Room = $".."
	var tiles = tilemap.get_used_cells()
	tiles.shuffle()
	
	for t in enemiesNumber:
		if tiles.size() == 0:
			return
		var enemyBase = QuestGenerator.enemy_list.pick_random().sceneRef		
		var obj = enemyBase.instantiate()
		add_child(obj)
		obj.position = Vector2(tiles[0].x, tiles[0].y) + room.global_position	
		tiles.remove_at(0)
		
	for t in collectiblesNumber:
		if tiles.size() == 0:
			return
		var collectibleBase = QuestGenerator.collectible_list.pick_random().sceneRef			
		var obj = collectibleBase.instantiate()
		add_child(obj)
		obj.position = Vector2(tiles[t].x, tiles[t].y) + room.global_position	
		tiles.remove_at(0)
