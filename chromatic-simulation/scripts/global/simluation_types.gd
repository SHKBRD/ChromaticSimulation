extends Node

enum SimulationType {
	DEFAULT,
	FIRST_TO_TEN
}

var defaultSimulation: Dictionary = {
	# Base amount for each agency to populate with Chromatics
	"startingAgencyCount" : 200,
	# Days to run the simulation
	"dayCount" : 365*2,
	# C1 days of rest
	"basemaxDaysOfRest" : 90,
	# Multiplier for allowed days of rest, multiplied for each class attained
	"daysOfRestIncreasePerClass" : 1.25,
	# Base willingness each chromatic has at the start of simulation
	"startingMissionWillingness" : 0.0015,
	# Willingness when a chromatic returns from a mission
	"resetMissionWillingness" : 0.0015,
	# Willingness increase rate per hour when not in mission
	"hourlyMissionWillingnessRestGrowth" : 0.00005,
	# Chromatic recruitment rate per agency, decimal is kept across tracking calculations
	"chromaticRecruitmentRate" : 0.5,
	# Possible mission selection time range, days
	"missionSelectionTimeRange" : [3, 14]
}

var firstToTenSimulation: Dictionary = {
	"startingAgencyCount" : 1000,
	"dayCount" : 365,
	"maxDaysOfRest" : 90
}

var simulationLookups: Dictionary[SimulationType, Dictionary] = {
	SimulationType.DEFAULT : defaultSimulation,
	SimulationType.FIRST_TO_TEN : firstToTenSimulation
}
