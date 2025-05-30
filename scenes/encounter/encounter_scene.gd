extends Node2D

@onready var game_state_manager: Node2D = $GameStateManager


@onready var players = [$Players/Player, $Players/Opponent]
var player_index = 0

@onready var board: Node2D = $"."
@onready var action_button: Button = $UI/ActionButton
@onready var quit: Button = $UI/Quit

@onready var card_manager: CardManager = $CardManager

@onready var player_ui: Control = $UI/PlayerUI
@onready var opponent_ui: Control = $UI/OpponentUI


	
func _process(_delta: float) -> void:
	pass

func _end_game():
	get_tree().change_scene_to_file("res://scenes/global/mapa.tscn")


func _on_turn_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	#var is_paused = not get_tree().paused
	#
	#quit.text = "Resume" if is_paused else "Pause"
	#get_tree().paused = is_paused
	_end_game()
