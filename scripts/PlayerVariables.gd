extends Node

var trackedData = {
	keyUsed = 0,
	timePassed = 0,
	ennemiesKilled = 0,
	timesPlayerGotHit = 0,
	timesEnnemiesGotHit = 0,
	currentRoom = "Room1",
	roomEnteredOrder = [],
	attacks = {
		number = 0,
		hitRate = 0,
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
		if event.keycode == KEY_U:
			print(getMostenteredRoomName())
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	trackedData.timePassed += delta
	pass

func getMostenteredRoomName() :
	var ElementMap = {}
	var maxOccurence = ["Room1", 0]
	for i in trackedData.roomEnteredOrder : 
		if i in ElementMap :
			ElementMap[i] += 1
		else :
			ElementMap[i] = 1
		if ElementMap[i] > maxOccurence[1] : 
			maxOccurence = [i, ElementMap[i]]
	return maxOccurence
