extends CollectibleBase


func on_collect() -> void:
	super()
	PlayerVariables.trackedData.pickupsObtained.hearts +=1
	Player.Instance.life += 1
