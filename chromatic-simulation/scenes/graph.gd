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

func _ready() -> void:
	var baseLinePlot: LinePlot = LinePlot.make_line_plot(Color.GREEN)
	baseLinePlot.xVals = [0, 1, 2, 3, 4, 5, 6, 7 , 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
	baseLinePlot.yVals = [20, 15, 20, 3, 42, 20, 10, 70, 30, 99, 95, 78, 32, 45, 2, 4, 8, 16, 32, 64]
	linePlots.append(baseLinePlot)

func _draw() -> void:
	draw_base()
	for plot: LinePlot in linePlots:
		draw_line_plot(plot)
	#draw_line(Vector2(4.0, 1.0), Vector2(4.0, 4.0), Color.GREEN, 2.0)
	#draw_line(Vector2(7.5, 1.0), Vector2(7.5, 4.0), Color.GREEN, 3.0)

func draw_base() -> void:
	draw_line(Vector2(0, 0), Vector2(0, height), Color(0.1, 0.1, 0.1), 5.0)
	draw_line(Vector2(0, height), Vector2(width, height), Color(0.1, 0.1, 0.1), 5.0)

func draw_line_plot(plot: LinePlot) -> void:
	var minX: float = plot.xVals.min()
	var maxX: float = plot.xVals.max()
	var minY: float = plot.yVals.min()
	var maxY: float = plot.yVals.max()
	var scale: Vector2 = Vector2(width/(maxX-minX), height/(maxY-minY))
	
	for plotPointInd: int in plot.xVals.size()-1:
		var plot1: Vector2 = Vector2(plot.xVals[plotPointInd], plot.yVals[plotPointInd])
		var plot2: Vector2 = Vector2(plot.xVals[plotPointInd+1], plot.yVals[plotPointInd+1])
		var adjPlot1: Vector2 = Vector2(plot1.x*scale.x-minX, height-(plot1.y*scale.y))
		var adjPlot2: Vector2 = Vector2(plot2.x*scale.x-minX, height-(plot2.y*scale.y))
		
		draw_line(adjPlot1, adjPlot2, plot.color, 3.0)
	

func _process(_delta) -> void:
	queue_redraw()
