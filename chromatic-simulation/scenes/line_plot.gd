extends Node
class_name LinePlot

const linePlotScene: PackedScene = preload("res://scenes/line_plot.tscn")

var xVals: Array = []
var yVals: Array = []
var color: Color
var label: String

static func make_line_plot(color: Color, label: String) -> LinePlot:
	var linePlot: LinePlot = linePlotScene.instantiate()
	linePlot.color = color
	linePlot.label = label
	return linePlot

func add_to_plot(xVal: float, yVal: float) -> void:
	xVals.append(xVal)
	yVals.append(yVal)
