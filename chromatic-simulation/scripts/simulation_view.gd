extends Node2D
class_name Simulation

static var simulationConfig: Dictionary
static var runningSimType: SimulationTypes.SimulationType

static func roll_chance(min: float, max: float, thresh: float) -> bool:
	var rollNum: float = RandomNumberGenerator.new().randf_range(min, max)
	return rollNum <= thresh

static var minDay: int = 1
static var maxDay: int = SimulationTypes.defaultSimulation.get("dayCount")
static var chosenDay: int = minDay

func _ready() -> void:
	update_chosen_day(chosenDay)

func start_simulation(simType: SimulationTypes.SimulationType):
	runningSimType = simType
	simulationConfig = SimulationTypes.simulationLookups[simType]
	%Organization.initialize_organization(simulationConfig.startingAgencyCount)
	simulation_loop()
	simulation_results()

func simulation_results() -> void:
	#for mission: Mission in %Organization.get_node("Missions").get_children():
		#print(mission.assignedChromatics.size())
	pass

func day_prints() -> void:
	var activeElimCount: Array[int] = %Organization.model.get_active_elim_count()
	print("DAY " + str(%Organization.model.day))
	print("ACTIVE: " + str(activeElimCount[0]))
	print("ELIMINATED: " + str(activeElimCount[1]))
	for agency: AgencyModel in %Organization.model.agencies:
		var agencyColorName: String = AgencyModel.AgencyColor.keys()[AgencyModel.AgencyColor.values().find(agency.agencyColor)]
		print(agencyColorName + ": " + str(agency.chromatics.size()))
		print("SCORE: " + str(agency.agencyScore) + " MAX CLASS: " + str(agency.get_highest_rank()))

func update_graphs() -> void:
	var day: int = %Organization.model.day
	for graph: Graph in %Graphs.graphs:
		match graph.type:
			Graph.GraphType.AGENCY_CHROMATIC_COUNT:
				for agencyInd: AgencyModel.AgencyColor in AgencyModel.AgencyColor.values():
					var agencyPopulation: int = %Organization.model.agencies[agencyInd].chromatics.size()
					graph.add_data(agencyInd, day, agencyPopulation)
			Graph.GraphType.AGENCY_HIGHEST_RANK:
				for agencyInd: AgencyModel.AgencyColor in AgencyModel.AgencyColor.values():
					graph.add_data(agencyInd, day, %Organization.model.agencies[agencyInd].get_highest_rank())
			Graph.GraphType.MISSION_COUNTS:
				graph.add_data(0, day, %Organization.model.upcomingMissions.size())
				graph.add_data(1, day, %Organization.model.activeMissions.size())
				graph.add_data(2, day, %Organization.model.completedMissions.size())
			Graph.GraphType.ACTIVE_ELIMINATED_CHROMATICS:
				var activeElimCount: Array[int] = %Organization.model.get_active_elim_count()
				
				graph.add_data(0, day, activeElimCount[0])
				graph.add_data(1, day, activeElimCount[1])
				graph.add_data(2, day, activeElimCount[0]+activeElimCount[1])
			Graph.GraphType.MISSION_SIZES:
				var sizeCount: Array = []
				for i: int in range(6):
					sizeCount.append(0)
				for mission: Mission in %Organization.model.completedMissions:
					sizeCount[mission.assignedChromatics.size()-1] += 1
				for countInd: int in sizeCount.size():
					graph.add_data(countInd, day, sizeCount[countInd])
			Graph.GraphType.POPULATION_BY_RANK:
				var rankCount: Array = []
				for i: int in range(Simulation.simulationConfig.maximumClassRank):
					rankCount.append(0)
				for agency: AgencyModel in %Organization.model.agencies:
					for chromatic: ChromaticModel in agency.chromatics:
						rankCount[chromatic.classRank-1] += 1
				for countInd: int in rankCount.size():
					graph.add_data(countInd, day, rankCount[countInd])

func simulation_loop() -> void:
	while %Organization.model.day < simulationConfig["dayCount"] or runningSimType == SimulationTypes.SimulationType.FIRST_TO_TEN:
		#day_prints()
		simulation_organization_day()
		%Organization.model.hour = 0
		%Organization.model.day += 1
		update_graphs()
		if runningSimType == SimulationTypes.SimulationType.FIRST_TO_TEN and %Organization.model.has_chromatic_of_rank(10):
			maxDay = %Organization.model.day
			return

func simulation_organization_day() -> void:
	%Organization.model.add_new_chromatic_progress()
	advance_all_resting_chromatic_status()
	advance_upcoming_mission_status()
	
	while %Organization.model.hour < 24:
		simulation_organization_hour(%Organization.model.hour)
		%Organization.model.hour += 1
	
	advance_active_missions()
	%Organization.model.update_agency_leaderboard()

func simulation_organization_hour(hour: int) -> void:
	advance_active_mission_status(hour)

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
	var engagementConsideration: float = 0.005
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
		creditsEarned *= %Organization.model.get_agency_elimination_bonus_mult(chromatic2.agency)
		#creditsEarned *= %Organization.model.get_agency_adjacency_bonus(chromatic1.agency, chromatic2.agency)
		chromatic1.award_credits(creditsEarned, chromatic2.classRank)
		chromatic2.eliminate()
	else:
		creditsEarned = pow(2, chromatic2.classRank-chromatic1.classRank)
		if not chromatic1PerfectResult:
			creditsEarned *= 2
		creditsEarned *= %Organization.model.get_agency_elimination_bonus_mult(chromatic1.agency)
		#creditsEarned *= %Organization.model.get_agency_adjacency_bonus(chromatic1.agency, chromatic2.agency)
		chromatic2.award_credits(creditsEarned, chromatic1.classRank)
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
		%Organization.model.activeMissions.erase(mission)
		%Organization.model.completedMissions.append(mission)
		#mission.get_parent().remove_child(mission)
			

func advance_all_resting_chromatic_status() -> void:
	var processChromatics: Array = get_tree().get_nodes_in_group("ActiveChromatics")
	processChromatics.shuffle()
	for chromatic: Chromatic in processChromatics:
		if chromatic.model.currentMission == null:
			chromatic.model.increase_mission_willingness()
			var decision: bool = chromatic.model.decide_to_go_on_mission()
			if decision:
				give_chromatic_mission(chromatic)

func give_chromatic_mission(chromatic: Chromatic) -> void:
	if %Organization.model.upcomingMissions.size() == 0:
		create_assign_mission(chromatic)
		return
	
	var missionList: Array = %Organization.model.upcomingMissions
	var sizeSplitMissions: Array = mission_list_split(missionList, chromatic.model.classRank, chromatic.model.agency, true)
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
		if mission.status == Mission.MissionStatus.UPCOMING and mission.assignedChromatics.size() != 6 and not mission.has_chromatic_of_agency(ignoredColor) and abs(mission.targetRank - availableRank) < 2:
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
	start_simulation(SimulationTypes.SimulationType.FIRST_TO_TEN)

func update_chosen_day(newDay: int) -> void:
	chosenDay = clamp(newDay, minDay, maxDay)
	%DayText.text = str(chosenDay)
	%DaySlider.value = chosenDay
	%DaySlider.min_value = minDay
	%DaySlider.max_value = maxDay
	%Graphs.update_visible_graph()
	

func _on_day_slider_value_changed(value: float) -> void:
	var newChosenInt: int = int(value)
	update_chosen_day(newChosenInt)


func _on_text_edit_text_submitted(new_text: String) -> void:
	var newTextInt: int = int(new_text)
	update_chosen_day(newTextInt)
