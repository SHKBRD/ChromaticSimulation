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
	var newLeaderboard: Array[AgencyModel] = []
	for times: int in range(agencyLeaderboard.size()):
		var maxScore: int = agencyLeaderboard.
		var maxAgency: AgencyModel
		for agency: AgencyModel in agencyLeaderboard:
			if agency.agencyScore > maxScore:
				
