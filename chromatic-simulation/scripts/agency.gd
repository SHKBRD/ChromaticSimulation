extends Node2D
class_name Agency

var chromaticScene: PackedScene = preload("res://scenes/chromatic.tscn")

func initialize_agency(color: AgencyModel.AgencyColor, amount: int) -> void:
	for chromaticInd: int in amount:
		var newChromatic: Chromatic = chromaticScene.instantiate()
		newChromatic.initialize_chromatic(color)
		
	%AgencyModel
	pass

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
