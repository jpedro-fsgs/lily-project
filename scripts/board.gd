extends Node2D

const CARD = preload("res://scenes/card.tscn")
@onready var players: Node2D = $Players
@onready var cards: Node2D = $Cards

var cards_deck = []

@onready var CentreCardOval = Vector2(get_viewport().size) * Vector2(0.5, 1.2)
@onready var Hor_rad = get_viewport().size.x * 0.45
@onready var Ver_rad = get_viewport().size.y * 0.4

var angle = 0
var OvalAngleVector: Vector2
const CardSpread = 0.25
var number_of_cards = 0

enum{
	InHand,
	InPlay,
	InMouse,
	FocusInHand,
	MoveDrawnCardToHand,
	ReOrganizeHand
}

func _ready() -> void:
	for card in CardDatabase.DATA:
		cards_deck.append(card)
	cards_deck.shuffle()

func draw_card():
	if cards_deck.is_empty():
		$Deck/DeckDraw.disabled = true
		return

	var new_card = CARD.instantiate()
	var card_data = cards_deck.pop_front()
	new_card.set_attributes(card_data)
	
	new_card._startpos = $Deck.position - new_card.size/2
	new_card._targetpos = 0
	
	new_card._startrot = 0
	new_card._targetrot = 0
	
	new_card.scale = Vector2(0.5, 0.5)
	new_card.state = InHand

	$Cards.add_child(new_card)

	number_of_cards += 1
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
		angle_step = (end_angle - start_angle) / (card_count)

	# Atualiza posição e rotação de cada carta
	for i in range(card_count):
		var card = hand[i]
		var current_angle = start_angle + angle_step * i
		var oval_pos = Vector2(Hor_rad * cos(current_angle), -Ver_rad * sin(current_angle))
		#
		card._targetpos = CentreCardOval + oval_pos - card.size/2
		card._targetrot = (90 - rad_to_deg(current_angle)) * 0.0075
		#card.animate_to_hand()
		card.change_state(MoveDrawnCardToHand)
