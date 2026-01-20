extends Node2D

enum door_position_tags_enum {
	NONE = 0,
	UP = 1 << 0,
	DOWN = 1 << 1,
	LEFT = 1 << 2,
	RIGHT = 1 << 3,
}

@onready var tile_map_layer : TileMapLayer = $TileMapLayer
@onready var rooms_data_node : Node2D = $RoomsData

var rooms_data_resource : Resource
var rooms_data_array : Array[room_data]
var tiles_to_fill : Array[CoordsAndDirection]
var occupied_tiles : Array[Vector2i]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rooms_data_resource = rooms_data_node.rooms_data_resource
	rooms_data_array = rooms_data_resource.room_datas

	print ("🤨")
	GenerateTree()
	set_process_input(true) 

	pass
	
	
func SpawnRoom(room_id : int, map_coords : Vector2i):
	tile_map_layer.set_cell(map_coords, 0, Vector2i(0, 0), room_id)
	pass
	
func HasDoorOn (room_direction : door_position_tags_enum, room_data_sub_resource : room_data) -> bool :
	return room_data_sub_resource.had_door & room_direction
	
func IsBeachDoor (room_direction : door_position_tags_enum, room_data_sub_resource : room_data) -> bool :
	return room_data_sub_resource.is_door_beach_type & room_direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if Input.is_key_pressed(KEY_SPACE):

	pass
	
func _input(ev):
	if ev is InputEventKey:
		if ev.keycode == KEY_SPACE and ev.pressed and not ev.echo:
			tile_map_layer.clear()
			GenerateTree()
	pass
	
func GenerateTree() :
	occupied_tiles.clear()
	tiles_to_fill.clear()
	
	var start_pos = Vector2i(0, 0)
	# SpawnRoom(1, start_pos) # will always only have 1 door going up
	
	# add empty tile coords to TILES TO BE FILLED
	var new_tile_to_fill : CoordsAndDirection = CoordsAndDirection.new()
	new_tile_to_fill.coords = start_pos + Vector2i.UP 
	new_tile_to_fill.direction = Vector2i.DOWN
	tiles_to_fill.push_back(new_tile_to_fill)
	
	# add both tiles to OCUPIED TILES
	occupied_tiles.push_back(start_pos)
	occupied_tiles.push_back(start_pos + Vector2i.UP)
	var room_count : int = 0
	
	while tiles_to_fill.is_empty() != true && room_count < 20:
		var tile = tiles_to_fill.pop_front()
		#for tile in tiles_to_fill:
			
		var compatible_rooms : Array[room_data]
		
		for room in rooms_data_array:
			
			# check neibor tile slots
			if !TestPossibleRoomInDirection(room, tile, door_position_tags_enum.UP) : continue
			if !TestPossibleRoomInDirection(room, tile, door_position_tags_enum.DOWN) : continue
			if !TestPossibleRoomInDirection(room, tile, door_position_tags_enum.LEFT) : continue
			if !TestPossibleRoomInDirection(room, tile, door_position_tags_enum.RIGHT) : continue
			
			compatible_rooms.append(room)
			pass
		
		var chosen_room : room_data = compatible_rooms.pick_random()
		
		if HasDoorOn(door_position_tags_enum.UP, chosen_room) && tile.direction != Vector2i.UP :
			print("up added")
			var new_tile : CoordsAndDirection = CoordsAndDirection.new()
			new_tile.coords = tile.coords + Vector2i.UP 
			new_tile.direction = Vector2i.DOWN
			new_tile.is_beach = IsBeachDoor(door_position_tags_enum.UP, chosen_room)
			tiles_to_fill.push_back(new_tile)
			occupied_tiles.append(new_tile.coords)
			SpawnRoom(13, new_tile.coords)
		if HasDoorOn(door_position_tags_enum.DOWN, chosen_room) && tile.direction != Vector2i.DOWN :
			print("down added")
			var new_tile : CoordsAndDirection = CoordsAndDirection.new()
			new_tile.coords = tile.coords + Vector2i.DOWN 
			new_tile.direction = Vector2i.UP
			new_tile.is_beach = IsBeachDoor(door_position_tags_enum.DOWN, chosen_room)
			tiles_to_fill.push_back(new_tile)
			occupied_tiles.append(new_tile.coords)
			SpawnRoom(13, new_tile.coords)
		if HasDoorOn(door_position_tags_enum.LEFT, chosen_room) && tile.direction != Vector2i.LEFT :
			print("left added")
			var new_tile : CoordsAndDirection = CoordsAndDirection.new()
			new_tile.coords = tile.coords + Vector2i.LEFT 
			new_tile.direction = Vector2i.RIGHT
			new_tile.is_beach = IsBeachDoor(door_position_tags_enum.LEFT, chosen_room)
			tiles_to_fill.push_back(new_tile)
			occupied_tiles.append(new_tile.coords)
			SpawnRoom(13, new_tile.coords)
		if HasDoorOn(door_position_tags_enum.RIGHT, chosen_room) && tile.direction != Vector2i.RIGHT :
			print("right added")
			var new_tile : CoordsAndDirection = CoordsAndDirection.new()
			new_tile.coords = tile.coords + Vector2i.RIGHT 
			new_tile.direction = Vector2i.LEFT
			new_tile.is_beach = IsBeachDoor(door_position_tags_enum.RIGHT, chosen_room)
			tiles_to_fill.push_back(new_tile)
			occupied_tiles.append(new_tile.coords)
			SpawnRoom(13, new_tile.coords)
		
		SpawnRoom(chosen_room.id, tile.coords)
		room_count += 1
		
		await get_tree().create_timer(1.0).timeout
		
		print(tiles_to_fill.size())
		pass
	pass
	
	if (tiles_to_fill.is_empty() == false) :
		for tile in tiles_to_fill:
			var possible_room_IDs : Array[int]
			
			for dead_end_tile_index in rooms_data_resource.dead_end_rooms_indexs :
				# check neibor tile slots
				var room : room_data = rooms_data_array[dead_end_tile_index]
				
				if !TestPossibleRoomInDirection(room, tile, door_position_tags_enum.UP) : continue
				if !TestPossibleRoomInDirection(room, tile, door_position_tags_enum.DOWN) : continue
				if !TestPossibleRoomInDirection(room, tile, door_position_tags_enum.LEFT) : continue
				if !TestPossibleRoomInDirection(room, tile, door_position_tags_enum.RIGHT) : continue
				
				possible_room_IDs.append(room.id)
				pass
			if possible_room_IDs.is_empty():
				print ("ERROR, no possible rooms !")
			else :
				SpawnRoom(possible_room_IDs.pick_random(), tile.coords)
			pass
		pass
	
func TestPossibleRoomInDirection (room : room_data, tile_to_fill : CoordsAndDirection, direction : door_position_tags_enum) -> bool:
	
	var vectorDirection : Vector2i
	match direction:
		door_position_tags_enum.UP:
			vectorDirection = Vector2i.UP
		door_position_tags_enum.DOWN:
			vectorDirection = Vector2i.DOWN
		door_position_tags_enum.LEFT:
			vectorDirection = Vector2i.LEFT
		door_position_tags_enum.RIGHT:
			vectorDirection = Vector2i.RIGHT
	
	if HasDoorOn(direction, room) :
		if tile_to_fill.direction == vectorDirection: # The door is leading to the tile's mother room. So all good. 
			if tile_to_fill.is_beach != IsBeachDoor(direction, room):
				return false
			pass 
		elif occupied_tiles.has(tile_to_fill.coords + vectorDirection) :
			return false # is there a door AND a room here ? that won't do. continue to the next room
	elif tile_to_fill.direction == vectorDirection:
		return false
	return true
	
	'''
	spawn thr starter room at 0, 0
	add door tile coords + direction of mother tile to TILES TO FILL
	add tile coords + door's tile coords to TILLS THAT ARE UNAVAILABLE
	
	while 'TILES TO FILL' list is NOT empty:
		for each DOOR in 'un-ended door' list:
			randomly select a possible room from PossibleRooms list
			get all the tile-slot coordinates that must be free for this room to be places (including larege room extentions and spce in front of doors). 
			if any of these tile-slot coordinates are not available, randomly select a smaller room. 
			if smaller room does not fit. Add smallest room (this will alwasy fit.)
			
			for each un-ended door in this new room:
				add to 'un-ended door list'
			remove DOOR from un-ended doors. 
	'''
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
		
	spawn thr starter room at 0, 0
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
