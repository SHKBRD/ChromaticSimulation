extends Control
class_name Graphs

var graphs: Array[Graph] = []

func _ready() -> void:
	var baseGraphs: Array = get_children()
	for graph: Graph in baseGraphs:
		graphs.append(graph)
