extends Node2D

func _ready():
	AudioManager.play_gameplay_music()

func _end_game():
	get_tree().change_scene_to_file("res://scenes/global/mapa.tscn")

func _on_quit_pressed() -> void:
	_end_game()
