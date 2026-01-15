extends Node2D

var starter_room_scene  = load("res://scenes/rooms/room_1.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# spawn scenes in scene
	#var starter_room_node = starter_room_scene.instantiate()
	#var starter_room_node2 = starter_room_scene.instantiate()
	#add_child(starter_room_node)
	#add_child(starter_room_node2)
	#starter_room_node2.position = Vector2(-350, 0)
	
	var tile_map_layer : TileMapLayer = $TileMapLayer
	tile_map_layer.set_cell(Vector2i(0, 0), 1, Vector2i(0, 0), 0)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

"""
psuedo code:
	
	imformation that must be provided by rooms:
		how many doors do you have
		info per door:
			what direction are you faceing ? 
			what tileOfThe room are you attached too ? (if the room has multiple tiles)
		based on a tile of the room, what surounding tiles do you take up ? (depicted by a list of Vector2). 
	
	
	get a list of all possible rooms. The rooms contain infromation of :
		where their doors are places
		what surrounding blocks tile-slotes they take up (if they are bigger than 1 tile)
		
	spawn thr starter room. 
	add the tile faces by starter rooms door to the 'un-ended door' list. 
	while 'un-ended door' list is NOT empty:
		for each DOOR in 'un-ended door' list:
			randomly select a possible room from PossibleRooms list
			get all the tile-slot coordinates that must be free for this room to be places (including larege room extentions and spce in front of doors). 
			if any of these tile-slot coordinates are not available, randomly select a smaller room. 
			if smaller room does not fit. Add smallest room (this will alwasy fit.)
			
			for each un-ended door in this new room:
				add to 'un-ended door list'
			remove DOOR from un-ended doors. 
	
			
	
"""

"""
to do 
	- spawn start room. -DONE
	- create a funtion that spawns rooms into "tile slots" based on their width/hight. (can I use a tileMap for this?)
"""
