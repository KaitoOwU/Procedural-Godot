class_name CollectibleBase extends Node

var collectible_type : QuestCollectible

func on_collect() -> void:
	QuestGenerator.complete_objective(collectible_type)
	pass

func _on_body_entered(body:Node2D) -> void:
	if !body is Player:
		return
		
	if(QuestGenerator.current_quest.is_empty()):
		return

	on_collect()
	queue_free()
