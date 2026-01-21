class_name Quest

var action : String
var element : QuestElement
var amount : int
var current_amount : int = 0

static func create(element: QuestElement, amount: int) -> Quest:
	var instance = Quest.new()
	if element is QuestEnemy:
		instance.action = "KILL"
	else:
		instance.action = "COLLECT"
	
	instance.element = element
	instance.amount = amount
	return instance
	
func _to_string() -> String:
	return str(action, " ", amount, " ", element.name)
