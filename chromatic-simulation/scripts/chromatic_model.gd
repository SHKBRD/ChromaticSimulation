extends Node
class_name ChromaticModel

var chromaticID: int

var agency: AgencyModel.AgencyColor

var classRank: int
var classCredits: float
var eliminated: bool

var currentMission: Mission
var missionWillingness: float

func initialize_model(color: AgencyModel.AgencyColor) -> void:
	agency = color
	classRank = 1
	classCredits = 0
	eliminated = false
	currentMission = null
	missionWillingness = Simulation.simulationConfig.startingMissionWillingness
	
	Chromatic.existingChromatics += 1
	chromaticID = Chromatic.existingChromatics

func decide_to_go_on_mission() -> bool:
	var chance: float = RandomNumberGenerator.new().randf_range(0.0, 1.0)
	return chance <= missionWillingness
	

func increase_mission_willingness() -> void:
	missionWillingness += Simulation.simulationConfig.hourlyMissionWillingnessRestGrowth
