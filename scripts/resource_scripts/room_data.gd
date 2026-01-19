class_name room_data extends Resource

@export var id : int
@export_flags("up", "down", "left", "right") var had_door : int = 0

#@export var sub_resources : Array[room_data]
