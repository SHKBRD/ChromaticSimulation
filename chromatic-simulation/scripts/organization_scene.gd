extends Node2D

var agencyScene: PackedScene = preload("res://scenes/agency.tscn")

func _ready() -> void:
	for agencyColor: AgencyModel.AgencyColor in AgencyModel.AgencyColor:
		var newAgency: Agency = agencyScene.instantiate()
		newAgency.initialize_agency(agencyColor, 500)
	pass
