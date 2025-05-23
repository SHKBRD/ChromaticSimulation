extends Node2D

var agencyScene: PackedScene = preload("res://scenes/agency.tscn")
var missionScene: PackedScene = preload("res://scenes/mission.tscn")

var model: OrganizationModel

func _ready() -> void:
	model = %OrganizationModel
	pass

func initialize_organization(chromaticAgencyCount: int) -> void:
	for agencyColor: String in AgencyModel.AgencyColor.keys():
		#print(agencyColor)
		var newAgency: Agency = agencyScene.instantiate()
		%AgencyScenes.add_child(newAgency)
		newAgency.initialize_agency(AgencyModel.AgencyColor[agencyColor], chromaticAgencyCount)
		%OrganizationModel.agencies.append(newAgency.get_node("AgencyModel"))
	model.update_agency_leaderboard()

func create_mission(rank: int) -> void:
	var newMission: Mission = missionScene.instantiate()
	newMission.targetRank = rank
	%Missions.add_child(newMission)
	model.upcomingMissions.append(newMission)
