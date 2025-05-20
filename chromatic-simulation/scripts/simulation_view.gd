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
	while %Organization.model.hour < 24:
		simulation_organization_hour()
		%Organization.model.hour += 1

func simulation_organization_hour() -> void:
	pass

func _on_start_button_pressed() -> void:
	start_simulation(SimulationTypes.SimulationType.DEFAULT)
