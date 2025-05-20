extends Node

enum SimulationType {
	DEFAULT,
	FIRST_TO_TEN
}

var defaultSimulation: Dictionary = {
	"startingAgencyCount" : 400,
	"dayCount" : 365,
}

var firstToTenSimulation: Dictionary = {
	"startingAgencyCount" : 400,
	"dayCount" : 365,
}

var simulationLookups: Dictionary[SimulationType, Dictionary] = {
	SimulationType.DEFAULT : defaultSimulation,
	SimulationType.FIRST_TO_TEN : firstToTenSimulation
}
