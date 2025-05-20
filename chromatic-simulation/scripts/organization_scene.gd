extends Node2D

var agencyScene: PackedScene = preload("res://scenes/agency.tscn")

func _ready() -> void:
	
	pass

func initialize_organization(chromaticAgencyCount: int) -> void:
	for agencyColor: AgencyModel.AgencyColor in AgencyModel.AgencyColor:
		var newAgency: Agency = agencyScene.instantiate()
		newAgency.initialize_agency(agencyColor, chromaticAgencyCount)
		%OrganizationModel.agencies.append(newAgency.get_node("AgencyModel"))
		%AgencyScenes.add_child(newAgency)
