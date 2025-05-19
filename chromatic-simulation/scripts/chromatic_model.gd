extends Node
class_name ChromaticModel

var chromaticID: int

var agency: AgencyModel.AgencyColor

var classRank: int
var classCredits: float

func initialize_model(color: AgencyModel.AgencyColor) -> void:
	agency = color
	classRank = 1
	classCredits = 0
	chromaticID = get_tree().get_nodes_in_group("guards").size()
