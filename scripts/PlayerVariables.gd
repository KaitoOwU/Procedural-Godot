extends Node

var trackedData = {
	keyUsed = 0,
	timePassed = 0,
	ennemiesKilled = 0,
	timesPlayerGotHit = 0,
	timesEnnemiesGotHit = 0,
	currentRoom = "Room1",
	Attacks = {
		Number = 0,
		HitRate = 0,
	},
	pickupsObtained = {
		hearts = 0,
		keys = 0,
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			print(trackedData)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	trackedData.timePassed += delta
	pass
