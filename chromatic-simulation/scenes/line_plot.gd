extends Node
class_name LinePlot

const linePlotScene: PackedScene = preload("res://scenes/line_plot.tscn")

var xVals: Array = []
var yVals: Array = []
var color: Color

static func make_line_plot(color: Color) -> LinePlot:
	var linePlot: LinePlot = linePlotScene.instantiate()
	linePlot.color = color
	return linePlot
