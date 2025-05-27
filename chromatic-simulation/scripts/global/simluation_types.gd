extends Node

enum SimulationType {
	DEFAULT,
	FIRST_TO_TEN
}

const defaultSimulation: Dictionary = {
	# Base amount for each agency to populate with Chromatics
	"startingAgencyCount" : 90,
	# Days to run the simulation
	"dayCount" : 365*1,
	# C1 days of rest
	"basemaxDaysOfRest" : 90,
	# Multiplier for allowed days of rest, multiplied for each class attained
	"daysOfRestIncreasePerClass" : 1.25,
	# Base willingness each chromatic has at the start of simulation
	"startingMissionWillingness" : 0.001,
	# Willingness when a chromatic returns from a mission
	"resetMissionWillingness" : 0.001,
	# Willingness increase rate per hour when not in mission
	"dailyMissionWillingnessRestGrowth" : 0.000015,
	# Chromatic recruitment rate per agency, decimal is kept across tracking calculations
	"chromaticRecruitmentRate" : 2/7.0,
	# Possible mission selection time range, days
	"missionSelectionTimeRange" : [14, 31],
	# Maximum Class rank a Chromatic can have
	"maximumClassRank" : 10
}

const firstToTenSimulation: Dictionary = {
	# Base amount for each agency to populate with Chromatics
	"startingAgencyCount" : 90,
	# Days to run the simulation
	"dayCount" : 365*1,
	# C1 days of rest
	"basemaxDaysOfRest" : 90,
	# Multiplier for allowed days of rest, multiplied for each class attained
	"daysOfRestIncreasePerClass" : 1.25,
	# Base willingness each chromatic has at the start of simulation
	"startingMissionWillingness" : 0.001,
	# Willingness when a chromatic returns from a mission
	"resetMissionWillingness" : 0.001,
	# Willingness increase rate per hour when not in mission
	"dailyMissionWillingnessRestGrowth" : 0.000015,
	# Chromatic recruitment rate per agency, decimal is kept across tracking calculations
	"chromaticRecruitmentRate" : 2/7.0,
	# Possible mission selection time range, days
	"missionSelectionTimeRange" : [14, 31],
	# Maximum Class rank a Chromatic can have
	"maximumClassRank" : 10
}

const simulationLookups: Dictionary[SimulationType, Dictionary] = {
	SimulationType.DEFAULT : defaultSimulation,
	SimulationType.FIRST_TO_TEN : firstToTenSimulation
}
