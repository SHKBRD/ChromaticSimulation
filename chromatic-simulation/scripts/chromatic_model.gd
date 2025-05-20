extends Node
class_name ChromaticModel

var chromaticID: int

var agency: AgencyModel.AgencyColor

var classRank: int
var classCredits: float
var eliminated: bool

var missionWillingness: float


func initialize_model(color: AgencyModel.AgencyColor) -> void:
	agency = color
	classRank = 1
	classCredits = 0
	eliminated = false
	Chromatic.existingChromatics += 1
	chromaticID = Chromatic.existingChromatics
