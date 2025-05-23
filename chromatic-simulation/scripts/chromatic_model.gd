extends Node
class_name ChromaticModel

var chromaticID: int

var agency: AgencyModel.AgencyColor

var classRank: int
var classCredits: float
var highestClassEliminated: int

var eliminated: bool

var currentMission: Mission
var missionWillingness: float

func initialize_model(color: AgencyModel.AgencyColor) -> void:
	agency = color
	#print(color)
	classRank = 1
	classCredits = 0
	eliminated = false
	currentMission = null
	highestClassEliminated = 1
	missionWillingness = Simulation.simulationConfig.startingMissionWillingness
	
	Chromatic.existingChromatics += 1
	chromaticID = Chromatic.existingChromatics

func decide_to_go_on_mission() -> bool:
	var chance: float = RandomNumberGenerator.new().randf_range(0.0, 1.0)
	return chance <= missionWillingness
	

func increase_mission_willingness() -> void:
	missionWillingness += Simulation.simulationConfig.hourlyMissionWillingnessRestGrowth

func award_credits(credits: float, rank: int) -> void:
	if rank > highestClassEliminated:
		highestClassEliminated = rank
	classCredits += credits
	while classCredits >= classRank and classRank < highestClassEliminated+1:
		classCredits -= classRank
		classRank += 1
	get_parent().get_parent().get_parent().agencyModel.update_agency_score()

func eliminate() -> void:
	#var preRemove: int = get_tree().get_nodes_in_group("ActiveChromatics").size()
	get_parent().remove_from_group("ActiveChromatics")
	get_parent().add_to_group("EliminatedChromatics")
	#var postRemove: int = get_tree().get_nodes_in_group("ActiveChromatics").size()
	
	
	
	var agency: Agency = get_parent().get_parent().get_parent()
	agency.agencyModel.chromatics.erase(self)
	agency.agencyModel.eliminatedChromatics.append(self)
	eliminated = true

func give_rest() -> void:
	currentMission = null
	missionWillingness = Simulation.simulationConfig.resetMissionWillingness
