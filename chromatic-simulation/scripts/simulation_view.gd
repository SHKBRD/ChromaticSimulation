extends Node2D
class_name Simulation

static var simulationConfig: Dictionary


func _ready() -> void:
	start_simulation(SimulationTypes.SimulationType.FIRST_TO_TEN)

func start_simulation(simType: SimulationTypes.SimulationType):
	simulationConfig = SimluationTypes.simulationLookups[simType]
	%Organization.initialize_organization(simulationConfig.startingAgencyCount)
	simulation_loop()
	
func simulation_loop() -> void:
	pass
