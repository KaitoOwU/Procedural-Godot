class_name Player extends CharacterBase

static var Instance : Player

@export_group("Input")
@export_range (0.0, 1.0) var controller_dead_zone : float = 0.3

# Collectible
var key_count : int


func _init() -> void:
	Instance = self


func _ready() -> void:
	_set_state(STATE.IDLE)


func _process(delta: float) -> void:
	super(delta)
	_update_inputs()
	_update_room()


func enter_room(room : Room) -> void:
	var previous = _room
	_room = room
	PlayerVariables.trackedData.roomEnteredOrder.append(room.name)
	if previous :
		PlayerVariables.trackedData.currentRoom = previous.name
	_room.on_enter_room(previous)


func _update_room() -> void:
	var room_bounds : Rect2 = _room.get_world_bounds()
	var next_room : Room = null
	var baseOffset : Vector2 =  Vector2(112,112)
	
	if position.x > room_bounds.end.x:
		next_room = _room.get_adjacent_room(Utils.ORIENTATION.EAST, room_bounds.position + baseOffset)
	elif position.x < room_bounds.position.x:
		next_room = _room.get_adjacent_room(Utils.ORIENTATION.WEST, room_bounds.position + baseOffset)
	elif position.y < room_bounds.position.y:
		next_room = _room.get_adjacent_room(Utils.ORIENTATION.NORTH, room_bounds.position + baseOffset)
	elif position.y > room_bounds.end.y:
		next_room = _room.get_adjacent_room(Utils.ORIENTATION.SOUTH, room_bounds.position + baseOffset)

	if next_room != null:
		enter_room(next_room)


func _update_inputs() -> void:
	if _can_move():
		_direction = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down"))
		if _direction.length() < controller_dead_zone:
			_direction = Vector2.ZERO
		else:
			_direction = _direction.normalized()

		if Input.is_action_pressed("Attack"):
			_attack()
	else:
		_direction = Vector2.ZERO

func _onAttack():
	PlayerVariables.trackedData.attacks.number+= 1
	var AttackNumber = PlayerVariables.trackedData.attacks.number
	PlayerVariables.trackedData.attacks.hitRate =  float(PlayerVariables.trackedData.timesEnnemiesGotHit)/AttackNumber if AttackNumber!= 0 else 0

func _set_state(state : STATE) -> void:
	super(state)
	match _state:
		STATE.STUNNED:
			_current_movement = stunned_movemement
		STATE.DEAD:
			print ("I'm Dead")
			_end_blink()
			_set_color(dead_color)
			get_tree().reload_current_scene()
		_:
			_current_movement = default_movement

	if !_can_move():
		_direction = Vector2.ZERO


func _update_state(_delta : float) -> void:
	match _state:
		STATE.ATTACKING:
			_spawn_attack_scene()
			_set_state(STATE.IDLE)

func _got_hit():
	PlayerVariables.trackedData.timesPlayerGotHit += 1
