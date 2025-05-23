extends Node2D
class_name Simulation

static var simulationConfig: Dictionary

static func roll_chance(min: float, max: float, thresh: float) -> bool:
	var rollNum: float = RandomNumberGenerator.new().randf_range(min, max)
	return rollNum <= thresh

func _ready() -> void:
	pass

func start_simulation(simType: SimulationTypes.SimulationType):
	simulationConfig = SimulationTypes.simulationLookups[simType]
	%Organization.initialize_organization(simulationConfig.startingAgencyCount)
	simulation_loop()
	simulation_results()

func simulation_results() -> void:
	#for mission: Mission in %Organization.get_node("Missions").get_children():
		#print(mission.assignedChromatics.size())
	pass

func day_prints() -> void:
	print("DAY " + str(%Organization.model.day))
	print("ACTIVE: " + str(get_tree().get_nodes_in_group("ActiveChromatics").size()))
	print("ELIMINATED: " + str(get_tree().get_nodes_in_group("EliminatedChromatics").size()))
	for agency: AgencyModel in %Organization.model.agencies:
		print(str(agency.agencyColor) + ": " + str(agency.chromatics.size()))

func simulation_loop() -> void:
	while %Organization.model.day < simulationConfig["dayCount"]:
		day_prints()
		simulation_organization_day()
		%Organization.model.hour = 0
		%Organization.model.day += 1

func simulation_organization_day() -> void:
	%Organization.model.add_new_chromatic_progress()
	advance_all_resting_chromatic_status()
	advance_upcoming_mission_status()
	
	while %Organization.model.hour < 24:
		simulation_organization_hour(%Organization.model.hour)
		%Organization.model.hour += 1
	
	advance_active_missions()

func simulation_organization_hour(hour: int) -> void:
	update_resting_chromatic_willingness()
	advance_active_mission_status(hour)

func update_resting_chromatic_willingness() -> void:
	var processChromatics: Array = get_tree().get_nodes_in_group("ActiveChromatics")
	processChromatics.shuffle()
	for chromatic: Chromatic in processChromatics:
		if chromatic.model.currentMission == null:
			chromatic.model.increase_mission_willingness()

func advance_upcoming_mission_status() -> void:
	var missions: Array = %Organization.model.upcomingMissions.duplicate()
	for mission: Mission in missions:
		if mission.status == Mission.MissionStatus.UPCOMING:
			mission.remainingDays -= 1
			if mission.remainingDays == -1:
				activate_mission(mission)

func activate_mission(mission: Mission) -> void:
	mission.status = Mission.MissionStatus.ACTIVE
	%Organization.model.upcomingMissions.erase(mission)
	%Organization.model.activeMissions.append(mission)

func advance_active_mission_status(hour: int) -> void:
	var missions: Array = %Organization.model.activeMissions.duplicate()
	for mission: Mission in missions:
		process_mission_encounters(mission, hour)

func process_mission_encounters(mission: Mission, hour: int) -> void:
	for chromatic: ChromaticModel in mission.assignedChromatics:
		if chromatic.eliminated:
			continue
		for focusChromatic: ChromaticModel in mission.assignedChromatics:
			if focusChromatic != chromatic and not focusChromatic.eliminated and not chromatic.eliminated:
				var decision: bool = decide_to_engage(chromatic, focusChromatic, mission, hour)
				if decision:
					start_encounter(mission, chromatic, focusChromatic)

func decide_to_engage(chromatic1: ChromaticModel, chromatic2: ChromaticModel, mission: Mission, hour: int) -> bool:
	var engagementConsideration: float = 0.25
	var hourConsideration: float = 1-(abs((hour-16)/24.0))
	engagementConsideration *= hourConsideration
	var classDifferenceConsideration: float = class_difference_consideration(engagementConsideration, chromatic1.classRank, chromatic2.classRank)
	engagementConsideration *= classDifferenceConsideration
	
	var decision: bool = roll_chance(0, 1, engagementConsideration)
	return decision
	
func class_difference_consideration(baseConsideration: float, class1: int, class2: int) -> float:
	if class1 == class2: return 1.0
	var classDifference: int = abs(class1 - class2)
	return pow(0.75, classDifference)


func start_encounter(mission: Mission, chromatic1: ChromaticModel, chromatic2: ChromaticModel) -> void:
	var chromatic1WinResult: bool = roll_chance(0, 1, class_difference_win_chance(chromatic1.classRank, chromatic2.classRank))
	var chromatic1PerfectResult: bool = roll_chance(0, 1, class_difference_win_chance(chromatic1.classRank, chromatic2.classRank))
	var creditsEarned: float
	if chromatic1WinResult:
		creditsEarned = pow(2, chromatic1.classRank-chromatic2.classRank)
		if chromatic1PerfectResult:
			creditsEarned *= 2
		chromatic1.award_credits(creditsEarned)
		chromatic2.eliminate()
	else:
		creditsEarned = pow(2, chromatic2.classRank-chromatic1.classRank)
		if not chromatic1PerfectResult:
			creditsEarned *= 2
		chromatic2.award_credits(creditsEarned)
		chromatic1.eliminate()
	
	
func class_difference_win_chance(initiatingClass: int, challengedClass: int) -> float:
	var classDifference: int = abs(initiatingClass - challengedClass)
	var biggerClass: int = max(initiatingClass, challengedClass)
	var differenceFactor: float = pow(biggerClass, classDifference/1.5)
	var winningChance: float = 1 - ( 1 / ( 2*differenceFactor ) )
	if initiatingClass < challengedClass:
		winningChance = 1-winningChance
	return winningChance

func advance_active_missions() -> void:
	var missions: Array[Mission] = %Organization.model.activeMissions.duplicate()
	for mission: Mission in missions:
		for chromatic: ChromaticModel in mission.assignedChromatics:
			chromatic.give_rest()
			

func advance_all_resting_chromatic_status() -> void:
	var processChromatics: Array = get_tree().get_nodes_in_group("ActiveChromatics")
	processChromatics.shuffle()
	for chromatic: Chromatic in processChromatics:
		if chromatic.model.currentMission == null:
			var decision: bool = chromatic.model.decide_to_go_on_mission()
			if decision:
				give_chromatic_mission(chromatic)

func give_chromatic_mission(chromatic: Chromatic) -> void:
	if %Organization.model.upcomingMissions.size() == 0:
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
	%Organization.create_mission(chromatic.model.classRank)
	%Organization.model.upcomingMissions.back().assign_chromatic(chromatic)

func mission_list_split(missionList: Array, availableRank: int, ignoredColor: AgencyModel.AgencyColor, shuffled: bool = false, clearEmpty: bool = true) -> Array:
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
