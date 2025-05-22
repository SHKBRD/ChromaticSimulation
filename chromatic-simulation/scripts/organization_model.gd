extends Node
class_name OrganizationModel


var agencies: Array[AgencyModel] = []
var upcomingMissions: Array[Mission] = []
var activeMissions: Array[Mission] = []
var completedMissions: Array[Mission] = []

var day: int
var hour: int

var chromaticEnrollProgress: float = 0.0

func add_new_chromatics() -> void:
	chromaticEnrollProgress += Simulation.simulationConfig.chromaticRecruitmentRate
	while chromaticEnrollProgress >= 1:
		enroll_new_chromatic()
		chromaticEnrollProgress -= 1

func enroll_new_chromatic() -> void:
	var smallestAgencyInd: int = 0
	for agencyInd: int in range(1, agencies.size()):
		if agencies[agencyInd].chromatics.size() < agencies[smallestAgencyInd].chromatics.size():
			smallestAgencyInd = agencyInd
	
