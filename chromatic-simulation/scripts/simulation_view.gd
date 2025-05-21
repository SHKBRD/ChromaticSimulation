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
			var decision: bool = chromatic.decide_to_go_on_mission()
			if decision:
				give_chromatic_mission(chromatic)
				
func _on_start_button_pressed() -> void:
	start_simulation(SimulationTypes.SimulationType.DEFAULT)
