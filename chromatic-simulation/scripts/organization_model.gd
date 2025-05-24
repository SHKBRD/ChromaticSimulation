extends Node
class_name OrganizationModel


var agencies: Array[AgencyModel] = []
var upcomingMissions: Array[Mission] = []
var activeMissions: Array[Mission] = []
var completedMissions: Array[Mission] = []

var agencyLeaderboard: Array[AgencyModel]

var day: int
var hour: int

var chromaticEnrollProgress: float = 0.0

func add_new_chromatic_progress() -> void:
	chromaticEnrollProgress += Simulation.simulationConfig.chromaticRecruitmentRate
	while chromaticEnrollProgress >= 1:
		enroll_new_chromatic()
		chromaticEnrollProgress -= 1

func enroll_new_chromatic() -> void:
	# choose smallest agency
	var smallestAgencyInd: int = 0
	for agencyInd: int in range(1, agencies.size()):
		if agencies[agencyInd].chromatics.size() < agencies[smallestAgencyInd].chromatics.size():
			smallestAgencyInd = agencyInd
	var chosenAgency: AgencyModel = agencies[smallestAgencyInd]
	chosenAgency.get_parent().add_chromatic(chosenAgency.agencyColor)

func update_agency_leaderboard() -> void:
	if agencyLeaderboard.size() == 0:
		agencyLeaderboard = agencies.duplicate()
	agencyLeaderboard.sort_custom(func(a: AgencyModel, b: AgencyModel): return a.agencyScore < b.agencyScore)
	
func get_agency_elimination_bonus_mult(agency: AgencyModel.AgencyColor) -> float:
	var placeInd: int = 0
	for agencyInd: int in agencyLeaderboard.size():
		if agencyLeaderboard[agencyInd].agencyColor == agency:
			placeInd = agencyInd
			break
	var mult: float = (agencyLeaderboard.size() - 1 - placeInd) * 0.2 + 1.0
	#print(mult)
	return mult

func get_agency_adjacency_bonus(agency1: AgencyModel.AgencyColor, agency2: AgencyModel.AgencyColor) -> float:
	var agency1Ind: int = 0
	for agencyFocusInd: int in agencyLeaderboard.size():
		if agencyLeaderboard[agencyFocusInd].agencyColor == agency1:
			agency1Ind = agencyFocusInd
			break
	var agency2Ind: int = 0
	for agencyFocusInd: int in agencyLeaderboard.size():
		if agencyLeaderboard[agencyFocusInd].agencyColor == agency2:
			agency2Ind = agencyFocusInd
			break
	var agencyPlacementBonus: float = 1 + pow(0.5, abs(agency1Ind - agency2Ind))
	print(agencyPlacementBonus)
	return agencyPlacementBonus
