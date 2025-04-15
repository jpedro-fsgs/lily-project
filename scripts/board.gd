class_name Board
extends Node2D

const CARD = preload("res://scenes/card.tscn")
@onready var players: Node2D = $Players
@onready var cards: Node2D = $Cards
@onready var board: Node2D = $"."
@onready var label: Label = $Label
@onready var card_slots: Node2D = $CardSlots

var cards_deck = []
var selected_card: Card

@onready var CentreCardOval = Vector2(get_viewport().size) * Vector2(0.5, 1.2)
@onready var Hor_rad = get_viewport().size.x * 0.45
@onready var Ver_rad = get_viewport().size.y * 0.4

var angle = 0
var OvalAngleVector: Vector2
@onready var CardSpread = get_viewport().size.x * 0.00014

func _ready() -> void:
	cards_deck = CardDatabase.get_cards()
	cards_deck.shuffle()
	
func _process(_delta: float) -> void:
	if selected_card:
		selected_card.position = (
			get_global_mouse_position()
			- (selected_card.size)/2 
		)

func draw_card():
	if cards_deck.is_empty():
		$DeckDraw/Cardback1.visible = false
		return

	var new_card = CARD.instantiate()
	var card_data = cards_deck.pop_front()
	new_card.set_attributes(card_data)
	
	new_card._startpos = $Deck.position - new_card.size/2
	
	new_card._startrot = 0
	
	new_card.scale = Vector2(0.5, 0.5)
	new_card.state = Card.MoveDrawnCardToHand

	$Cards.add_child(new_card)
	new_card.connect("card_selected", Callable(self, "_on_card_selected"))
	new_card.connect("card_released", Callable(self, "_on_card_released"))

	_update_hand()

func _update_hand():
	var hand = $Cards.get_children()
	var card_count = hand.size()

	if card_count == 0:
		return

	# Calcula o ângulo inicial e final para distribuir as cartas em arco
	var start_angle = PI/2 + CardSpread * (card_count-1) / 2
	var end_angle = PI/2 - CardSpread * (card_count-1) / 2

	# Distribuição do ângulo entre as cartas
	var angle_step = 0
	if card_count > 1:
		angle_step = (end_angle - start_angle) / (card_count - 1)

	# Atualiza posição e rotação de cada carta
	for i in range(card_count):
		var card = hand[i]
		var current_angle = start_angle + angle_step * i
		var oval_pos = Vector2(Hor_rad * cos(current_angle), -Ver_rad * sin(current_angle))
		#
		card._targetpos = CentreCardOval + oval_pos - card.size/2
		card._targetrot = (90 - rad_to_deg(current_angle)) * 0.0075
		card.change_state(Card.InHand)


func _on_card_selected(card: Card) -> void:
	selected_card = card
	card.change_state(Card.InMouse)
	label.text = card._name
	
func _on_card_released(card: Card) -> void:
	selected_card = null
	label.text = ""
	for card_slot in card_slots.get_children():
		if card.drop_point_detector.get_overlapping_areas().has(card_slot.card_slot_detector):
			print(card.drop_point_detector.get_overlapping_areas())
			card_slot.add_card(card)
			_update_hand()
			return
	
	card.change_state(Card.InHand)
