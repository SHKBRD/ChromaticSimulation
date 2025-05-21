extends Node2D
class_name Simulation

static var simulationConfig: Dictionary


func _ready() -> void:
	pass

func start_simulation(simType: SimulationTypes.SimulationType):
	simulationConfig = SimulationTypes.simulationLookups[simType]
	%Organization.initialize_organization(simulationConfig.startingAgencyCount)
	simulation_loop()
	
func simulation_loop() -> void:
	while %Organization.model.day < simulationConfig["dayCount"]:
		simulation_organization_day()
		%Organization.model.hour = 0
		%Organization.model.day += 1

func simulation_organization_day() -> void:
	advance_all_resting_chromatic_status()
	
	while %Organization.model.hour < 24:
		simulation_organization_hour()
		%Organization.model.hour += 1

func simulation_organization_hour() -> void:
	pass

func advance_all_resting_chromatic_status() -> void:
	var processChromatics: Array = get_tree().get_nodes_in_group("ActiveChromatics")
	processChromatics.shuffle()
	for chromatic: Chromatic in processChromatics:
		if chromatic.model.currentMission != null:
			var decision: bool = chromatic.model.decide_to_go_on_mission()
			if decision:
				give_chromatic_mission(chromatic)
			else:
				chromatic.model.update_mission_willingness()

func give_chromatic_mission(chromatic: Chromatic) -> void:
	if %Organization.model.missions.size() == 0:
		%Organization.model.create_mission()
		%Organization.model.missions[0].assign_chromatic(chromatic)
		return
	
	var missionList: Array[Mission] = (%Organization.get_node("Missions").get_children() as Array[Mission])
	var sizeSplitMissions: Array = mission_list_split(missionList, true)
	

func mission_list_split(missionList: Array[Mission], shuffled: bool = false) -> Array:
	var sizeSplitMissions: Array = [[], [], [], [], [], []]
	for mission: Mission in missionList:
		sizeSplitMissions[mission.assignedChromatics.size()-1].append(mission)
	if shuffled:
		for sizeArrInd: int in sizeSplitMissions.size():
			sizeSplitMissions[sizeArrInd].shuffle()
	return sizeSplitMissions

func _on_start_button_pressed() -> void:
	start_simulation(SimulationTypes.SimulationType.DEFAULT)
