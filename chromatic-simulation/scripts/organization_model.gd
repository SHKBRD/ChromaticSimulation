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
	agencyLeaderboard.sort_custom(func(a: AgencyModel, b: AgencyModel): return a.agencyScore > b.agencyScore)
	
func get_agency_elimination_bonus(agency: AgencyModel.AgencyColor) -> float:
	var placeInd: int = agencyLeaderboard.find_custom((func(focusAgency: AgencyModel): focusAgency.agencyColor == agency).bind())
	return placeInd * 0.4
