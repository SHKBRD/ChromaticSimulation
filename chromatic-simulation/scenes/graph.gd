extends Control
class_name Graph

enum GraphType {
	AGENCY_CHROMATIC_COUNT,
	AGENCY_HIGHEST_RANK,
	MISSION_COUNTS,
	ACTIVE_ELIMINATED_CHROMATICS,
	MISSION_SIZES,
	POPULATION_BY_RANK
}

const graphTitles: Dictionary[GraphType, String] = {
	GraphType.AGENCY_CHROMATIC_COUNT : "Chromatic Count By Agency",
	GraphType.AGENCY_HIGHEST_RANK : "Highest Rank in Agency",
	GraphType.MISSION_COUNTS : "Mission Counts By Type",
	GraphType.ACTIVE_ELIMINATED_CHROMATICS : "Chromatic Count",
	GraphType.MISSION_SIZES : "Mission Size",
	GraphType.POPULATION_BY_RANK : "Chromatics with Rank"
}

@export var type: GraphType

var linePlots: Array[LinePlot]

@export var width: float = 300
@export var height: float = 200

var graphScale: Dictionary = {
	"minX" : 0,
	"minY" : 0,
	"maxX" : 0,
	"maxY" : 0,
	"scale" : Vector2(),
}

func _ready() -> void:
	init_graph(type)
	#var baseLinePlot: LinePlot = LinePlot.make_line_plot(Color.GREEN, "TEST")
	#baseLinePlot.xVals = [0, 1, 2, 3, 4, 5, 6, 7 , 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
	#baseLinePlot.yVals = [20, 15, 20, 3, 42, 20, 10, 70, 30, 99, 95, 78, 32, 45, 2, 4, 8, 16, 32, 64]
	#linePlots.append(baseLinePlot)
	#
	#var baseLinePlot2: LinePlot = LinePlot.make_line_plot(Color.BLUE, "TEST")
	#baseLinePlot2.xVals = [0, 1, 2, 3, 4, 5, 6, 7 , 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 30]
	#baseLinePlot2.yVals = [20, 15, 20, 3, 42, 20, 10, 70, 30, 99, 95, 78, 32, 45, 2, 4, 8, 16, 32, 64]
	#linePlots.append(baseLinePlot2)
	
	update_graph_scale()
	
func init_graph(type: GraphType) -> void:
	
	match type:
		GraphType.AGENCY_CHROMATIC_COUNT: 
			var agencyColors: Dictionary[AgencyModel.AgencyColor, Dictionary] = {
				AgencyModel.AgencyColor.RED : {"color" : Color.RED, "label" : "Red"},
				AgencyModel.AgencyColor.BLUE : {"color" : Color.BLUE, "label" : "Blue"},
				AgencyModel.AgencyColor.GREEN : {"color" : Color.GREEN, "label" : "Green"},
				AgencyModel.AgencyColor.PURPLE : {"color" : Color.PURPLE, "label" : "Purple"},
				AgencyModel.AgencyColor.ORANGE : {"color" : Color.ORANGE, "label" : "Orange"},
				AgencyModel.AgencyColor.PINK : {"color" : Color.PINK, "label" : "Pink"},
			}
			for agency: AgencyModel.AgencyColor in AgencyModel.AgencyColor.values():
				var newLinePlot = LinePlot.make_line_plot(agencyColors[agency].color, agencyColors[agency].label)
				linePlots.append(newLinePlot)
				
		GraphType.AGENCY_HIGHEST_RANK:
			var agencyColors: Dictionary[AgencyModel.AgencyColor, Dictionary] = {
				AgencyModel.AgencyColor.RED : {"color" : Color.RED, "label" : "Red"},
				AgencyModel.AgencyColor.BLUE : {"color" : Color.BLUE, "label" : "Blue"},
				AgencyModel.AgencyColor.GREEN : {"color" : Color.GREEN, "label" : "Green"},
				AgencyModel.AgencyColor.PURPLE : {"color" : Color.PURPLE, "label" : "Purple"},
				AgencyModel.AgencyColor.ORANGE : {"color" : Color.ORANGE, "label" : "Orange"},
				AgencyModel.AgencyColor.PINK : {"color" : Color.PINK, "label" : "Pink"},
			}
			for agency: AgencyModel.AgencyColor in AgencyModel.AgencyColor.values():
				var newLinePlot = LinePlot.make_line_plot(agencyColors[agency].color, agencyColors[agency].label)
				linePlots.append(newLinePlot)
		GraphType.MISSION_COUNTS:
			var missionTypes: Dictionary[String, Dictionary] = {
				"upcoming" : {"color" : Color.SLATE_BLUE, "label" : "Upcoming"},
				"active" : {"color" : Color.YELLOW, "label" : "Active"},
				"completed" : {"color" : Color.BLACK, "label" : "Completed"},
			}
			for missionType: String in missionTypes.keys():
				var newLinePlot = LinePlot.make_line_plot(missionTypes[missionType].color, missionTypes[missionType].label)
				linePlots.append(newLinePlot)
		GraphType.ACTIVE_ELIMINATED_CHROMATICS:
			var chromaticStatuses: Dictionary[String, Dictionary] = {
				"active" : {"color" : Color.GREEN, "label" : "Active"},
				"eliminated" : {"color" : Color.RED, "label" : "Eliminated"},
				"total" : {"color" : Color.YELLOW, "label" : "Total"},
			}
			for chromaticStatus: String in chromaticStatuses.keys():
				var newLinePlot = LinePlot.make_line_plot(chromaticStatuses[chromaticStatus].color, chromaticStatuses[chromaticStatus].label)
				linePlots.append(newLinePlot)
		GraphType.MISSION_SIZES:
			pass
		GraphType.POPULATION_BY_RANK:
			pass

func update_graph_scale() -> void:
	var masterX: Array = []
	var masterY: Array = []
	for plot: LinePlot in linePlots:
		masterX.append_array(plot.xVals)
		masterY.append_array(plot.yVals)
		
	if masterX.is_empty() or masterY.is_empty():
		graphScale = {
			"minX" : 0,
			"minY" : 0,
			"maxX" : 0,
			"maxY" : 0,
			"scale" : Vector2(),
		}
		return
	
	var minX: float = masterX.min()
	var maxX: float = masterX.max()
	var minY: float = masterY.min()
	var maxY: float = masterY.max()
	var newGraphScale: Vector2 = Vector2(width/(maxX-minX), height/(maxY-minY))
	graphScale = {
		"minX" : minX,
		"minY" : minY,
		"maxX" : maxX,
		"maxY" : maxY,
		"scale" : newGraphScale,
	}


func _draw() -> void:
	draw_base()
	for plot: LinePlot in linePlots:
		draw_line_plot(plot)
	draw_name()
	#draw_line(Vector2(4.0, 1.0), Vector2(4.0, 4.0), Color.GREEN, 2.0)
	#draw_line(Vector2(7.5, 1.0), Vector2(7.5, 4.0), Color.GREEN, 3.0)

func draw_base() -> void:
	draw_line(Vector2(0, 0), Vector2(0, height), Color(0.1, 0.1, 0.1), 5.0)
	draw_line(Vector2(0, height), Vector2(width, height), Color(0.1, 0.1, 0.1), 5.0)

func draw_line_plot(plot: LinePlot) -> void:
	if plot.xVals.is_empty() or plot.yVals.is_empty():
		return
	
	#var minX: float = plot.xVals.min()
	#var maxX: float = plot.xVals.max()
	#var minY: float = plot.yVals.min()
	#var maxY: float = plot.yVals.max()
	#var scale: Vector2 = Vector2(width/(maxX-minX), height/(maxY-minY))
	
	for plotPointInd: int in plot.xVals.size()-1:
		var plot1: Vector2 = Vector2(plot.xVals[plotPointInd], plot.yVals[plotPointInd])
		var plot2: Vector2 = Vector2(plot.xVals[plotPointInd+1], plot.yVals[plotPointInd+1])
		var adjPlot1: Vector2 = Vector2(plot1.x*graphScale.scale.x-graphScale.minX, height-((plot1.y-graphScale.minY)*graphScale.scale.y))
		var adjPlot2: Vector2 = Vector2(plot2.x*graphScale.scale.x-graphScale.minX, height-((plot2.y-graphScale.minY)*graphScale.scale.y))
		
		draw_line(adjPlot1, adjPlot2, plot.color, 3.0)
	

func draw_name() -> void:
	draw_string(ThemeDB.fallback_font, Vector2(0, height+20), graphTitles[type])

func _process(_delta) -> void:
	queue_redraw()

func add_data(linePlotInd: int, xVal: float, yVal: float) -> void:
	linePlots[linePlotInd].add_to_plot(xVal, yVal)
	update_graph_scale()
