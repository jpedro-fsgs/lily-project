extends Node2D
class_name CardManager

const CARD: PackedScene = preload("res://scenes/encounter/card.tscn")

var player_deck = []
var opponent_deck = []

@onready var game_state_manager: GameStateManager = $"../GameStateManager"
@onready var player_card_hand: CanvasLayer = $"../Players/Player/PlayerHand"
@onready var opponent_card_hand: CanvasLayer = $"../Players/Opponent/OpponentHand"

@onready var player: Player = $"../Players/Player"

var selected_card: Card = null

signal view_card(card: Card)
signal focus_hand(focus: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_deck = EncounterSetup.get_player_deck()
	opponent_deck = EncounterSetup.get_opponent_deck()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func draw_card_player():
	if player_deck.is_empty():
		return null
	var card_data = player_deck.pop_front()
	var new_card = CARD.instantiate()
	new_card.set_attributes(card_data)
	
	new_card.connect("card_selected", Callable(self, "_on_card_selected"))
	new_card.connect("card_released", Callable(self, "_on_card_released"))
	new_card.connect("card_hovered", Callable(self, "_on_card_hovered"))
	new_card.connect("card_unhovered", Callable(self, "_on_card_unhovered"))
	
	player_card_hand.add_child(new_card)
	player_card_hand.update_hand()
	return new_card
	
func draw_card_opponent():
	if opponent_deck.is_empty():
		return null
	var card_data = opponent_deck.pop_front()
	var new_card = CARD.instantiate()
	new_card.set_attributes(card_data, true)
	opponent_card_hand.add_child(new_card)
	opponent_card_hand.update_hand()
	return new_card
	
	
# Called when a card is clicked or selected.
func _on_card_selected(card: Card) -> void:
	match card.field:
		Card.fields.Hand:
			#emit_signal("view_card", null)
			pass
		Card.fields.Bench:
			selected_card = card
			card.change_state(Card.states.InMouse)
	
	

func _on_card_released(card: Card) -> void:
	match card.field:
		Card.fields.Hand:
			game_state_manager.player_buy_card(card)
		Card.fields.Bench:
			selected_card = null
			if card.drop_point_detector.get_overlapping_areas().has(player.drop_detector):
				game_state_manager.player_play_card(card)
			else:
				card.change_state(Card.states.InBench)

			


# Called when the mouse cursor enters the card's area.
func _on_card_hovered(card) -> void:
	match card.field:
		Card.fields.Hand:
			card.change_state(Card.states.FocusInHand)
			emit_signal("view_card", card)
			emit_signal("focus_hand", true)
		Card.fields.Bench:
			emit_signal("view_card", card)
	
func _on_card_unhovered(card: Card) -> void:
	match card.field:
		Card.fields.Hand:
			card.change_state(Card.states.InHand)
			emit_signal("view_card", null)
			emit_signal("focus_hand", false)
		Card.fields.Bench:
			emit_signal("view_card", null)
