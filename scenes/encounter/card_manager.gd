extends Node2D
class_name CardManager

const CARD: PackedScene = preload("res://scenes/encounter/card.tscn")

var player_deck = []
var opponent_deck = []

@onready var player_field_card_slots: Node2D = $"../Players/Player/PlayerField/CardSlots"
@onready var player_bench_card_slots: Node2D = $"../Players/Player/PlayerBench/CardSlots"


@onready var game_state_manager: GameStateManager = $"../GameStateManager"
@onready var player_card_hand: CanvasLayer = $"../Players/Player/PlayerHand"
@onready var opponent_card_hand: CanvasLayer = $"../Players/Opponent/OpponentHand"

@onready var bench_drop_detector: Area2D = $"../Players/Player/BenchDropDetector"
@onready var field_drop_detector: Area2D = $"../Players/Player/FieldDropDetector"


@onready var player: Player = $"../Players/Player"

var selected_card: Card = null
var mouse_position_on_selected_card: Vector2

signal view_card(card: Card)
signal focus_hand(focus: bool)

var is_hovering := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_deck = EncounterSetup.get_player_deck()
	opponent_deck = EncounterSetup.get_opponent_deck()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if selected_card:
		selected_card.global_position = get_global_mouse_position() - mouse_position_on_selected_card * selected_card.scale

func draw_card_player():
	if player_deck.is_empty():
		return null
	var card_data = player_deck.pop_front()
	var new_card = CARD.instantiate()
	new_card.set_attributes(card_data)
	new_card.belongs_to = GameStateManager.players.PLAYER
	
	new_card.connect("card_selected", Callable(self, "_on_card_selected"))
	new_card.connect("card_released", Callable(self, "_on_card_released"))
	new_card.connect("card_hovered", Callable(self, "_on_card_hovered"))
	new_card.connect("card_unhovered", Callable(self, "_on_card_unhovered"))
	new_card.connect("dead_card", Callable(self, "kill_card"))
	
	player_card_hand.add_child(new_card)
	player_card_hand.update_hand()
	return new_card
	
func draw_card_opponent():
	if opponent_deck.is_empty():
		return null
	var card_data = opponent_deck.pop_front()
	var new_card = CARD.instantiate()
	new_card.set_attributes(card_data, true)
	new_card.belongs_to = GameStateManager.players.OPPONENT
	
	new_card.connect("card_hovered", Callable(self, "_on_card_hovered"))
	new_card.connect("card_unhovered", Callable(self, "_on_card_unhovered"))
	new_card.connect("dead_card", Callable(self, "kill_card"))
	
	opponent_card_hand.add_child(new_card)
	opponent_card_hand.update_hand()
	return new_card
	
	
# Called when a card is clicked or selected.
func _on_card_selected(card: Card, mouse_position_on_card: Vector2) -> void:
	match card.field:
		Card.fields.Hand:
			selected_card = card
			mouse_position_on_selected_card = mouse_position_on_card
			card.change_state(Card.states.InMouse)
		Card.fields.Bench:
			selected_card = card
			mouse_position_on_selected_card = mouse_position_on_card
			card.change_state(Card.states.InMouse)
		Card.fields.Combat:
			selected_card = card
			mouse_position_on_selected_card = mouse_position_on_card
			card.change_state(Card.states.InMouse)

func _on_card_released(card: Card) -> void:
	match card.field:
		Card.fields.Hand:
			selected_card = null
			if card.drop_point_detector.get_overlapping_areas().has(bench_drop_detector):
				if game_state_manager.player_buy_card(card):
					return
			
			card.change_state(Card.states.InHand)
		Card.fields.Bench:
			selected_card = null
			for card_slot in player_field_card_slots.get_children():
				if card.drop_point_detector.get_overlapping_areas().has(card_slot.card_slot_detector):
					if not card_slot.card:
						if game_state_manager.player_play_card(card, false, card_slot):
							return
			
			card.change_state(Card.states.InBench)
		Card.fields.Combat:
			selected_card = null
			for card_slot in player_field_card_slots.get_children():
				if card.drop_point_detector.get_overlapping_areas().has(card_slot.card_slot_detector):
					if not card_slot.card:
						if game_state_manager.player_reallocate_card(card, false, card_slot):
							return
						
			card.change_state(Card.states.InField)
# Called when the mouse cursor enters the card's area.
func _on_card_hovered(card) -> void:
	if selected_card:
		return

	match card.field:
		Card.fields.Hand:
			if card.belongs_to == GameStateManager.players.OPPONENT:
				return
			card.change_state(Card.states.FocusInHand)
			emit_signal("view_card", card)
			emit_signal("focus_hand", true)
		Card.fields.Bench:
			emit_signal("view_card", card)
		Card.fields.Combat:
			emit_signal("view_card", card)
	
func _on_card_unhovered(card: Card) -> void:
	if selected_card:
		return
		
	match card.field:
		Card.fields.Hand:
			card.change_state(Card.states.InHand)
			emit_signal("view_card", null)
			emit_signal("focus_hand", false)
		Card.fields.Bench:
			emit_signal("view_card", null)
		Card.fields.Combat:
			emit_signal("view_card", null)
			
func kill_card(card: Card):
	print_debug("3")
	var card_slot = card.card_slot;
	card_slot.remove_card(card)
	card.queue_free()
	
