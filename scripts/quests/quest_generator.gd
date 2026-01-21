class_name quest_generator extends Node

var objective : Array[String] = ["COLLECT", "KILL"]
var collectible_list : Array[QuestCollectible]
var enemy_list : Array[QuestEnemy]

var current_quest : Array[Quest]

var labels_container : VBoxContainer
var label = preload("res://resources/ui/quest_label.tscn")
var questUI

var random = RandomNumberGenerator.new();

func _ready() -> void:
	questUI = get_tree().current_scene.get_node("Camera2D/UI/QuestMenuTop") as Control
	questUI.visible = false
	
	labels_container = get_tree().current_scene.get_node("Camera2D/UI/QuestMenuTop/QuestText/VBoxContainer")
	read_item_dir()

func generate_quests() -> bool:
	if(current_quest.is_empty() == false):
		return false
	
	current_quest = generate_quest()
	questUI.visible = true
	update_labels()
	return true

func generate_quest() -> Array[Quest]:
	var quest_list : Array[Quest] = []
	
	var t_objective = objective.duplicate()
	var t_collectible_list = collectible_list.duplicate()
	var t_enemy_list = enemy_list.duplicate()
	
	var amount_objectives = random.randi_range(1, 4)
	
	for i in range(0, amount_objectives):
		var current_obj = t_objective.pick_random()
		match current_obj:
			"COLLECT":
				var quest = create_item_quest_from(t_collectible_list)
				t_collectible_list.erase(quest.element as QuestCollectible)
				quest_list.append(quest)
				
			"KILL":
				var quest = create_enemy_quest_from(t_enemy_list)
				t_enemy_list.erase(quest.element as QuestEnemy)
				quest_list.append(quest)

	for q in quest_list:
		print(q._to_string())
	return quest_list
	
func read_item_dir() -> void:
	for res in ResourceLoader.list_directory("res://resources/collectibles/"):
		collectible_list.append(load("res://resources/collectibles/" + res) as QuestCollectible)
		
	for res in ResourceLoader.list_directory("res://resources/enemies/"):
		enemy_list.append(load("res://resources/enemies/" + res) as QuestEnemy)
		
		
func create_item_quest_from(list: Array[QuestCollectible]) -> Quest:
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
			quest.current_amount += 1
			if quest.current_amount >= quest.amount:
				current_quest.erase(quest)
		continue
		
	update_labels()
	if(current_quest.is_empty):
		questUI.visible = false
	return current_quest.is_empty()
	
func update_labels() -> void:
	for child in labels_container.get_children():
		child.queue_free()
	
	for i in range(0, current_quest.size()):
		var label_instance : QuestLabel = label.instantiate() as QuestLabel
		labels_container.add_child(label_instance)
		label_instance.setup_label(current_quest.get(i))
		pass
