extends Node
class_name Mission

enum MissionStatus {
	UPCOMING,
	ACTIVE,
	DONE
}

var remainingDays: int
var status: MissionStatus
var assignedChromatics: Array[ChromaticModel]

func _ready() -> void:
	initialize_mission()

func initialize_mission() -> void:
	var config: Dictionary = Simulation.simulationConfig
	var possibleApplyLengthRange: Array = Simulation.simulationConfig["missionSelectionTimeRange"]
	var randomPickDays: int = RandomNumberGenerator.new().randi_range(possibleApplyLengthRange[0], possibleApplyLengthRange[1])
	remainingDays = randomPickDays
	status = MissionStatus.UPCOMING

func has_chromatic_of_agency(color: AgencyModel.AgencyColor) -> bool:
	for chromatic: ChromaticModel in assignedChromatics:
		if chromatic.agency == color: return true
	return false

func assign_chromatic(chromatic: Chromatic) -> void:
	assignedChromatics.append(chromatic.model)
