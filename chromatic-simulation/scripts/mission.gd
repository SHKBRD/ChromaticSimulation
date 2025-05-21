extends Node
class_name Mission

var missionRemainingDays: int

func _ready() -> void:
	initialize_mission()

func initialize_mission() -> void:
	var possibleApplyLengthRange: Range = Simulation.simulationConfig["missionSelectionTimeRange"]
	var randomPickDays: int = RandomNumberGenerator.new().randi_range(possibleApplyLengthRange.min_value, possibleApplyLengthRange.max_value)
	missionRemainingDays = randomPickDays
