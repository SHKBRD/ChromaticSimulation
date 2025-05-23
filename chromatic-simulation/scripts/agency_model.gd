extends Node
class_name AgencyModel

enum AgencyColor {
	RED,
	BLUE,
	GREEN,
	PURPLE,
	ORANGE,
	PINK
}

var agencyColor: AgencyColor
var chromatics: Array[ChromaticModel]
var eliminatedChromatics: Array[ChromaticModel]
var missionAvailableChromatics: Array[ChromaticModel]

var agencyScore: int

func _ready() -> void:
	pass

func update_agency_score() -> void:
	agencyScore = 0
	for chromatic : ChromaticModel in chromatics:
		agencyScore += pow(2, chromatic.classRank)

func get_highest_rank() -> int:
	var highestRank: int = 1
	for chromatic : ChromaticModel in chromatics:
		if chromatic.classRank > highestRank:
			highestRank = chromatic.classRank
	return highestRank
		
