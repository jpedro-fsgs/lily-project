class_name GameManager
extends Node2D

const CARD = preload("res://scenes/encounter/card.tscn")
const PLAYER = preload("res://scenes/encounter/player.tscn")

@onready var players: Array[Player] = [$Players/Lily, $Players/Opponent]
var player_index = 0

@onready var board: Node2D = $"."
@onready var turn_button: Button = $UI/TurnButton
@onready var quit: Button = $UI/Quit

@onready var player_field: Node2D = $Board/PlayerField
@onready var opponent_field: Node2D = $Board/OpponentField

@onready var player_hp: Label = $UI/PlayerHP
@onready var opponent_hp: Label = $UI/OpponentHP


var current_player: Player

var selected_card: Card

signal turn_changed(index)

func _ready() -> void:
	players[0].set_player_type(Player.HumanPlayer)
	players[0].index = 0
	players[1].set_player_type(Player.Opponent)
	players[1].index = 1
	current_player = players[0]
	
	update_hp()
	initial_cards()
	
func _process(_delta: float) -> void:
	if selected_card:
		selected_card.position = (
			get_global_mouse_position()
			- (selected_card.size)/2 
		)
		
		
func update_hp():
	player_hp.text = str("HP: ", players[0].HP)
	opponent_hp.text = str("HP: ", players[1].HP)
		
func change_player_turn():
	player_index += 1
	if player_index >= players.size():
		player_index = 0
	current_player = players[player_index]
	if player_index == 0:
		turn_button.text = "Your Turn"
	else:
		turn_button.text = "Opponent's Turn"
	emit_signal("turn_changed", player_index)

func draw_card(player: Player):
	if player.cards_deck.is_empty():
		return
		
	
	var card_data = player.cards_deck.pop_front()
	var new_card = CARD.instantiate()
	new_card.set_attributes(card_data)
	new_card._startpos = $DeckDraw.position - new_card.size/2
	new_card._startpos = Vector2(1160, 40)
	new_card._startrot = 0
	new_card.scale = Vector2(0.5, 0.5)
	
	new_card.connect("card_selected", Callable(self, "_on_card_selected"))
	new_card.connect("card_released", Callable(self, "_on_card_released"))
	
	self.connect("turn_changed", Callable(new_card, "_on_turn_changed"))
	
	player.add_card_to_hand(new_card)
	


func _on_card_selected(card: Card) -> void:
	get_tree().call_group("cards", "_set_hover_state", false)
	selected_card = card
	card.change_state(Card.states.InMouse)
	
func _on_card_released(card: Card) -> void:
	get_tree().call_group("cards", "_set_hover_state", true)
	selected_card = null
	if current_player.player_type == Player.HumanPlayer:
		for card_slot in player_field.get_children():
			if card.drop_point_detector.get_overlapping_areas().has(card_slot.card_slot_detector):
				card_slot.add_card(card, players[0], players[1])
				change_player_turn()
				return
	else:
		for card_slot in opponent_field.get_children():
			if card.drop_point_detector.get_overlapping_areas().has(card_slot.card_slot_detector):
				card_slot.add_card(card, players[1], players[0])
				change_player_turn()
				return
	
	card.change_state(Card.states.InHand)

func initial_cards():
	for i in range(4):
		draw_card(players[0])
		draw_card(players[1])
		await get_tree().create_timer(0.25).timeout
		
	emit_signal("turn_changed", player_index)
	
	if player_index == 0:
		turn_button.text = "Your Turn"
	else:
		turn_button.text = "Opponent's Turn"

func _on_deck_draw_clicked() -> void:
	draw_card(current_player)
	change_player_turn()

func _end_game():
	get_tree().change_scene_to_file("res://scenes/global/main.tscn")


func _on_turn_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	#var is_paused = not get_tree().paused
	#
	#quit.text = "Resume" if is_paused else "Pause"
	#get_tree().paused = is_paused
	_end_game()


func _on_lily_update_hp(hp: int) -> void:
	player_hp.text = str("HP: ", hp)
	if hp < 10:
		player_hp.add_theme_color_override("font_color", Color.RED)
	if hp <= 0:
		_end_game()


func _on_opponent_update_hp(hp: int) -> void:
	opponent_hp.text = str("HP: ", hp)
	if hp < 10:
		opponent_hp.add_theme_color_override("font_color", Color.RED)
	if hp <= 0:
		_end_game()
