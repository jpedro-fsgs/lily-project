extends Node2D

const CARD = preload("res://scenes/encounter/card.tscn")
const PLAYER = preload("res://scenes/encounter/player.tscn")

@onready var game_state_manager: Node2D = $GameStateManager


@onready var players = [$Players/Player, $Players/Opponent]
var player_index = 0

@onready var board: Node2D = $"."
@onready var action_button: Button = $UI/ActionButton
@onready var quit: Button = $UI/Quit

@onready var card_manager: CardManager = $CardManager


@onready var player_ui: Control = $UI/PlayerUI
@onready var opponent_ui: Control = $UI/OpponentUI


var current_player
signal turn_changed(index)

func _ready() -> void:
	players[0].index = 0
	players[1].index = 1
	current_player = players[0]
	
	update_hp()
	game_state_manager.initial_cards()
	
func _process(_delta: float) -> void:
	pass
		
func update_hp():
	player_ui.set_hp(players[0].HP)
	opponent_ui.set_hp(players[1].HP)
		
func change_player_turn():
	player_index += 1
	if player_index >= players.size():
		player_index = 0
	current_player = players[player_index]
	if player_index == 0:
		action_button.text = "Your Turn"
	else:
		action_button.text = "Opponent's Turn"
	emit_signal("turn_changed", player_index)

#func draw_card(player):
	#if player.cards_deck.is_empty():
		#return
		#
	#
	#var card_data = player.cards_deck.pop_front()
	#var new_card = CARD.instantiate()
	#new_card.set_attributes(card_data)
	#new_card._startpos = Vector2(1160, 40)
	#new_card._startrot = 0
	#new_card.scale = Vector2(0.5, 0.5)
	#
	#new_card.connect("card_selected", Callable(self, "_on_card_selected"))
	#new_card.connect("card_released", Callable(self, "_on_card_released"))
	#
	#self.connect("turn_changed", Callable(new_card, "_on_turn_changed"))
	#
	#player.add_card_to_hand(new_card)
	#


#func _on_card_selected(card: Card) -> void:
	#get_tree().call_group("cards", "_set_hover_state", false)
	#selected_card = card
	#card.change_state(Card.states.InMouse)
	#
#func _on_card_released(card: Card) -> void:
	#get_tree().call_group("cards", "_set_hover_state", true)
	#selected_card = null
	#if current_player.player_type == Player.HumanPlayer:
		#if card.drop_point_detector.get_overlapping_areas().has(player_field.field_detector):
			#player_field.add_card(card)
			#change_player_turn()
			#return
			#
		#if card.drop_point_detector.get_overlapping_areas().has(player_bench.bench_detector):
			#player_bench.add_card(card)
			#change_player_turn()
			#return
	#card.change_state(Card.states.InHand)

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
