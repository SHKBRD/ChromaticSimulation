extends Node2D
class_name Chromatic

static var existingChromatics: int = 0

var model: ChromaticModel

func _ready() -> void:
	model = %ChromaticModel

func _process(delta: float) -> void:
	pass

func initialize_chromatic(color: AgencyModel.AgencyColor) -> void:
	%ChromaticModel.initialize_model(color)
	
