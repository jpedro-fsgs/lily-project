extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.timeline_ended.connect(ended)
	Dialogic.start("timeline")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ended():
	get_tree().change_scene_to_file("res://scenes/mapa.tscn")
