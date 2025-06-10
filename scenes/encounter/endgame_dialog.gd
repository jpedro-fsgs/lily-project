extends CanvasLayer
class_name EndgameDialog

@onready var label: Label = $Label

func set_winner(winner):
	label.text = winner


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/global/mapa.tscn")
