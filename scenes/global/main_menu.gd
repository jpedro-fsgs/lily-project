extends Control

@onready var tema_da_lily: AudioStreamPlayer = $TemaDaLily


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/global/mapa.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/global/options.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
