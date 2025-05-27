extends Control
class_name Graphs

var graphs: Array[Graph] = []
var visibleGraphInd: int = 0

func _ready() -> void:
	var baseGraphs: Array = get_children()
	for graph: Graph in baseGraphs:
		graphs.append(graph)

func update_visible_graph() -> void:
	get_child(visibleGraphInd).queue_redraw()

func update_graph_visibility(newInd: int) -> void:
	var graphCount: int = get_children().size()
	if newInd >= graphCount:
		newInd = newInd % graphCount
	if newInd < 0:
		newInd = graphCount + (newInd%graphCount)
	get_child(visibleGraphInd).hide()
	get_child(newInd).show()
	visibleGraphInd = newInd
	
	update_visible_graph()


func _on_left_pressed() -> void:
	update_graph_visibility(visibleGraphInd-1)


func _on_right_pressed() -> void:
	update_graph_visibility(visibleGraphInd+1)
