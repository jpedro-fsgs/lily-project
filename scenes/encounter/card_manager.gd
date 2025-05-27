extends Node2D
class_name CardManager

const CARD: PackedScene = preload("res://scenes/encounter/card.tscn")

var player_deck = []
var opponent_deck = []

@onready var player_card_hand: Node2D = $"../Players/Player/CardHand"
@onready var opponent_card_hand: Node2D = $"../Players/Opponent/CardHand"

var selected_card: Card = null

signal view_card(card: Card)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_deck = CardDatabase.get_deck(CardDatabase.DeckType.PUREZA)
	opponent_deck = CardDatabase.get_deck(CardDatabase.DeckType.RAIVA)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	new_card.set_attributes(card_data)
	
	opponent_card_hand.add_child(new_card)
	opponent_card_hand.update_hand()
	return new_card
	
	
# Called when a card is clicked or selected.
func _on_card_selected(card) -> void:
	selected_card = card
	#card.change_state(Card.states.InMouse)
	
	

func _on_card_released(card) -> void:
	# Example: Print the name of the released card
	print("Card released/unhovered: ", card._name)
	selected_card = null
	#card.change_state(Card.states.InHand)
	if card.
	emit_signal("view_card", null)


# Called when the mouse cursor enters the card's area.
func _on_card_hovered(card) -> void:
	if selected_card:
		return
	print("Card hovered: ", card._name)
	card.change_state(Card.states.FocusInHand)
	emit_signal("view_card", card)
	
func _on_card_unhovered(card) -> void:
	if selected_card:
		return
	# Example: Print the name of the hovered card
	print("Card unhovered: ", card._name)
	card.change_state(Card.states.InHand)
	emit_signal("view_card", null)
