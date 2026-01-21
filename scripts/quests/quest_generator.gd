class_name quest_generator extends Node

var objective : Array[String] = ["COLLECT", "KILL"]
var item_list : Array[QuestItem]
var enemy_list : Array[QuestEnemy]

var current_quest : Array[Quest]

var random = RandomNumberGenerator.new();

func _ready() -> void:
	read_item_dir()
	#current_quest = generate_quest()

func generate_quest() -> Array[Quest]:
	var quest_list : Array[Quest] = []
	
	var t_objective = objective
	var t_item_list = item_list
	var t_enemy_list = enemy_list
	
	var amount_objectives = random.randi_range(1, 4)
	
	for i in range(0, amount_objectives):
		var current_obj = t_objective.pick_random()
		match current_obj:
			"COLLECT":
				var quest = create_item_quest_from(t_item_list)
				t_item_list.erase(quest.element as QuestItem)
				quest_list.append(quest)
				
			"KILL":
				var quest = create_enemy_quest_from(t_enemy_list)
				t_enemy_list.erase(quest.element as QuestEnemy)
				quest_list.append(quest)

	for q in quest_list:
		print(q._to_string())
	return quest_list
	
func read_item_dir() -> void:
	for res in ResourceLoader.list_directory("res://resources/items/"):
		item_list.append(load("res://resources/items/" + res) as QuestItem)
		
	for res in ResourceLoader.list_directory("res://resources/enemies/"):
		enemy_list.append(load("res://resources/enemies/" + res) as QuestEnemy)
		
		
func create_item_quest_from(list: Array[QuestItem]) -> Quest:
	var element = list.pick_random()
	var count = random.randi_range(1, 4)
	
	var quest = Quest.create(element, count)
	return quest


func create_enemy_quest_from(list: Array[QuestEnemy]) -> Quest:
	var element = list.pick_random()
	var count = random.randi_range(1, 2)
	
	var quest = Quest.create(element, count)
	return quest
	
func complete_objective(obj: QuestElement) -> bool:
	for quest in current_quest:
		if quest.element == obj:
			quest.amount -= 1
			if quest.amount <= 0:
				current_quest.erase(quest)
		continue
	return current_quest.is_empty()
