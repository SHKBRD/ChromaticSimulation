extends Node2D
class_name Agency

var chromaticScene: PackedScene = preload("res://scenes/chromatic.tscn")

var agencyModel: AgencyModel

func initialize_agency(color: AgencyModel.AgencyColor, amount: int) -> void:
	for chromaticInd: int in amount:
		var newChromatic: Chromatic = chromaticScene.instantiate()
		%ChromaticScenes.add_child(newChromatic)
		newChromatic.initialize_chromatic(color)
		%AgencyModel.chromatics.append(newChromatic.get_node("ChromaticModel"))
	
	pass

func _ready() -> void:
	agencyModel = %AgencyModel
	
func _process(delta: float) -> void:
	pass
