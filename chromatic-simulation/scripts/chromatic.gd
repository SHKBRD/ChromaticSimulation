extends Node2D
class_name Chromatic

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func initialize_chromatic(color: AgencyModel.AgencyColor) -> void:
	%ChromaticModel.initialize_model(color)
	
