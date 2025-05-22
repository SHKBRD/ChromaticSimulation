extends Node
class_name OrganizationModel


var agencies: Array[AgencyModel] = []
var upcomingMissions: Array[Mission] = []
var activeMissions: Array[Mission] = []
var completedMissions: Array[Mission] = []

var day: int
var hour: int

var chromaticEnrollProgress: float = 0.0
