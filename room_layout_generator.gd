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

var rooms_data_array : Array[room_data]
var tiles_to_fill : Array[CoordsAndDirection]
var occupied_tiles : Array[Vector2i]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rooms_data_resource : Resource = rooms_data_node.rooms_data_resource
	rooms_data_array = rooms_data_resource.room_datas

	pass
	
	
func SpawnRoom(room_id : int, map_coords : Vector2i):
	tile_map_layer.set_cell(map_coords, 0, Vector2i(0, 0), room_id)
	pass
	
func HasDoorOn (room_direction : door_position_tags_enum, room_data_sub_resource : room_data) -> bool :
	return ((room_data_sub_resource.had_door & room_direction) == 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func GenerateTree() :
	var start_pos = Vector2i(0, 0)
	SpawnRoom(1, start_pos) # will always only have 1 door going up
	
	# add empty tile coords to TILES TO BE FILLED
	var new_tile_to_fill : CoordsAndDirection
	new_tile_to_fill.coords = start_pos + Vector2i.UP 
	new_tile_to_fill.coords = Vector2i.DOWN
	tiles_to_fill.push_back(new_tile_to_fill)
	
	# add both tiles to OCUPIED TILES
	occupied_tiles.push_back(start_pos)
	occupied_tiles.push_back(start_pos + Vector2i.UP)
	
	while tiles_to_fill.is_empty() != true :
		for tile in tiles_to_fill:
			
			for room in rooms_data_array:
				
				# check neibor tile slots
				
				# UP
				if (HasDoorOn(door_position_tags_enum.UP, room) == true && occupied_tiles.has(tile.coords + Vector2i.UP)) :
					if tile.direction == Vector2i.UP:
						pass # we know that there is a room & door here and we don't care
					elif occupied_tiles.has(tile.coords + Vector2i.UP) :
						continue # is there a door AND a room here ? that won't do. continue to the next room

				pass
			pass
		pass
	
	
func TestPossibleRoom (room : room_data, tile_to_fill : CoordsAndDirection, direction : door_position_tags_enum):
	pass
	
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
