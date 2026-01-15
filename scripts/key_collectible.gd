extends CollectibleBase


func on_collect() -> void:
	super()
	PlayerVariables.trackedData.pickupsObtained.keys +=1
	Player.Instance.key_count += 1


func _on_body_entered(body:Node2D) -> void:
	super(body)
