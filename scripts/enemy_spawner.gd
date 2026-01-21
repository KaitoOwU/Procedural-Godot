class_name EntitySpawner extends Node

@onready var spawnTileMap : TileMapLayer = $"../TileMapLayer_FLOOR"
@onready var sandTilesRef : TileMapLayer = $"/root/game_scene/Help/SandTiles"
@onready var waterTilesRef : TileMapLayer = $"/root/game_scene/Help/WaterTiles"

@onready var unusedEnemyMap : TileMapLayer = $"../TileMapLayer_ENEMYSPAWN" #quick fix

var sandTiles : Array[Vector2i]
var waterTiles : Array[Vector2i]

var enemiesNumber : int
var collectiblesNumber : int


func _ready() -> void:
	unusedEnemyMap.visible = false
	
	await get_tree().create_timer(0.2).timeout # wait for other generations
	
	enemiesNumber = randi_range(1, 2)
	collectiblesNumber = randi_range(1, 3)
	_parseTileMap(spawnTileMap)
	_spawnEntitiesInZone()

func _spawnEntitiesInZone() -> void:
	var room : Room = $".."
	
	for t in enemiesNumber:
		if waterTiles.size() == 0:
			return
		var enemyBase = QuestGenerator.enemy_list.pick_random().sceneRef
		var obj = enemyBase.instantiate()
		add_child(obj)
		obj.position = Vector2(waterTiles[0].x, waterTiles[0].y) * 16 + room.global_position
		waterTiles.remove_at(0)
		
	for t in collectiblesNumber:
		if sandTiles.size() == 0:
			return
		var collectibleBase = QuestGenerator.collectible_list.pick_random().sceneRef
		var obj = collectibleBase.instantiate()
		add_child(obj)
		obj.position = Vector2(sandTiles[t].x, sandTiles[t].y) * 16 + room.global_position	+ Vector2(8, 8)
		sandTiles.remove_at(0)


func _parseTileMap(tilemap: TileMapLayer)-> void :
	var allTiles = tilemap.get_used_cells()
	allTiles.shuffle()
	
	var usedSandTiles = sandTilesRef.get_used_cells()
	var usedWaterTiles = waterTilesRef.get_used_cells()
	
	for t in allTiles:
		var tile_added = false
		var coords = tilemap.get_cell_atlas_coords(t)
		for s in usedSandTiles:
			if coords == sandTilesRef.get_cell_atlas_coords(s):
				sandTiles.append(t)
				tile_added = true
				break
		if(tile_added):
			continue
		for w in usedWaterTiles:
			if coords == waterTilesRef.get_cell_atlas_coords(w):
				waterTiles.append(t)
				tile_added = true
				break
