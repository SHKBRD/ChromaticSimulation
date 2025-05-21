extends Node2D
class_name Simulation

static var simulationConfig: Dictionary


func _ready() -> void:
	pass

func start_simulation(simType: SimulationTypes.SimulationType):
	simulationConfig = SimulationTypes.simulationLookups[simType]
	%Organization.initialize_organization(simulationConfig.startingAgencyCount)
	simulation_loop()
	simulation_results()

func simulation_results() -> void:
	for mission: Mission in %Organization.get_node("Missions").get_children():
		print(mission.assignedChromatics.size())

func simulation_loop() -> void:
	while %Organization.model.day < simulationConfig["dayCount"]:
		print("DAY " + str(%Organization.model.day))
		simulation_organization_day()
		%Organization.model.hour = 0
		%Organization.model.day += 1

func simulation_organization_day() -> void:
	advance_all_resting_chromatic_status()
	advance_all_mission_status()
	
	while %Organization.model.hour < 24:
		simulation_organization_hour()
		%Organization.model.hour += 1

func simulation_organization_hour() -> void:
	update_resting_chromatic_willingness()

func update_resting_chromatic_willingness() -> void:
	var processChromatics: Array = get_tree().get_nodes_in_group("ActiveChromatics")
	processChromatics.shuffle()
	for chromatic: Chromatic in processChromatics:
		if chromatic.model.currentMission == null:
			chromatic.model.increase_mission_willingness()

func advance_all_mission_status() -> void:
	var missions: Array = %Organization.model.missions
	for mission: Mission in missions:
		if mission.status == Mission.MissionStatus.UPCOMING:
			mission.remainingDays -= 1
			if mission.remainingDays == -1:
				mission.status = Mission.MissionStatus.ACTIVE

func advance_all_resting_chromatic_status() -> void:
	var processChromatics: Array = get_tree().get_nodes_in_group("ActiveChromatics")
	processChromatics.shuffle()
	for chromatic: Chromatic in processChromatics:
		if chromatic.model.currentMission == null:
			var decision: bool = chromatic.model.decide_to_go_on_mission()
			if decision:
				give_chromatic_mission(chromatic)

func give_chromatic_mission(chromatic: Chromatic) -> void:
	if %Organization.model.missions.size() == 0:
		create_assign_mission(chromatic)
		return
	
	var missionList: Array = %Organization.get_node("Missions").get_children()
	var sizeSplitMissions: Array = mission_list_split(missionList, chromatic.model.agency ,true)
	var maxSizeInd: int = RandomNumberGenerator.new().randi_range(-1, sizeSplitMissions.size()-1)
	if maxSizeInd == -1:
		create_assign_mission(chromatic)
	else:
		var chosenMissionSizeInd: int = RandomNumberGenerator.new().randi_range(0, maxSizeInd)
		var chosenMissionList: Array = sizeSplitMissions[chosenMissionSizeInd]
		var chosenMissionInd: int = RandomNumberGenerator.new().randf_range(0, chosenMissionList.size()-1)
		var chosenMission: Mission = chosenMissionList[chosenMissionInd]
		chosenMission.assign_chromatic(chromatic)
		chromatic.model.currentMission = chosenMission

func create_assign_mission(chromatic: Chromatic) -> void:
	%Organization.create_mission()
	%Organization.model.missions.back().assign_chromatic(chromatic)

func mission_list_split(missionList: Array, ignoredColor: AgencyModel.AgencyColor, shuffled: bool = false, clearEmpty: bool = true) -> Array:
	var sizeSplitMissions: Array[Array] = [[], [], [], [], []]
	for mission: Mission in missionList:
		# Filter out full missions
		if mission.status == Mission.MissionStatus.UPCOMING and mission.assignedChromatics.size() != 6 and not mission.has_chromatic_of_agency(ignoredColor):
			sizeSplitMissions[mission.assignedChromatics.size()-1].append(mission)
	
	if clearEmpty:
		for listInd: int in range(sizeSplitMissions.size()-1, -1, -1):
			if sizeSplitMissions[listInd].is_empty():
				sizeSplitMissions.remove_at(listInd)
	
	if shuffled:
		for sizeArrInd: int in sizeSplitMissions.size():
			sizeSplitMissions[sizeArrInd].shuffle()
	
	return sizeSplitMissions

func _on_start_button_pressed() -> void:
	start_simulation(SimulationTypes.SimulationType.DEFAULT)
