extends Node2D

var scene_index = 0
const scenes = [
	"res://scenes/main_menu.tscn",
	"res://scenes/first_cutscene.tscn",
	"res://scenes/game_manager.tscn"
	]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func next_scene():
	get_tree().change_scene_to_file(scenes[scene_index])
	scene_index += 1
