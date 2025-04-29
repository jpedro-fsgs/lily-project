class_name GameManager
extends Node2D

const CARD = preload("res://scenes/card.tscn")
const PLAYER = preload("res://scenes/player.tscn")

@onready var players: Array[Player] = [$Players/Lily, $Players/Opponent]
var player_index = 0

@onready var board: Node2D = $"."
@onready var label: Label = $Label
@onready var card_slots: Node2D = $CardSlots

var current_player: Player

var cards_deck = []
var selected_card: Card



func _ready() -> void:

	players[0].set_player_type(Player.HumanPlayer)
	players[1].set_player_type(Player.Opponent)
	current_player = players[0]
	
	cards_deck = CardDatabase.get_cards()
	cards_deck.shuffle()
	
func _process(_delta: float) -> void:
	if selected_card:
		selected_card.position = (
			get_global_mouse_position()
			- (selected_card.size)/2 
		)
		
func change_player_turn():
	player_index += 1
	if player_index >= players.size():
		player_index = 0
	current_player = players[player_index]

func draw_card(player: Player):
	if cards_deck.is_empty():
		return
		
	var new_card = CARD.instantiate()
	var card_data = cards_deck.pop_front()
	
	new_card.set_attributes(card_data)
	#new_card._startpos = $DeckDraw.position - new_card.size/2
	new_card._startpos = Vector2(1160, 40)
	new_card._startrot = 0
	new_card.scale = Vector2(0.5, 0.5)
	
	new_card.connect("card_selected", Callable(self, "_on_card_selected"))
	new_card.connect("card_released", Callable(self, "_on_card_released"))
	
	player.add_card_to_hand(new_card)
	
	if cards_deck.is_empty():
		_end_game()
		$DeckDraw/Cardback1.visible = false


func _on_card_selected(card: Card) -> void:
	get_tree().call_group("cards", "_set_hover_state", false)
	selected_card = card
	card.change_state(Card.states.InMouse)
	label.text = str(card._cost)
	
func _on_card_released(card: Card) -> void:
	get_tree().call_group("cards", "_set_hover_state", true)
	selected_card = null
	label.text = ""
	for card_slot in card_slots.get_children():
		if card.drop_point_detector.get_overlapping_areas().has(card_slot.card_slot_detector):
			card_slot.add_card(card)
			return
	
	card.change_state(Card.states.InHand)


func _on_deck_draw_clicked() -> void:
	draw_card(current_player)
	change_player_turn()

func _end_game():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
