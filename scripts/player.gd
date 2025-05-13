class_name Player
extends Node2D

@onready var card_hand: Node2D = $CardHand

enum {
	HumanPlayer,
	Opponent
}

var player_type = HumanPlayer

var HP = 100
var defense = 0

var cards_deck = []

var your_turn = false
var index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cards_deck = CardDatabase.get_deck(CardDatabase.DeckType.LIRIO_DO_VALE)
	cards_deck.shuffle()
			
func set_player_type(type):
	player_type = type
	match type:
		HumanPlayer:
			card_hand.set_cards_position(card_hand.BOTTOM)
			cards_deck = CardDatabase.get_deck(CardDatabase.DeckType.LIRIO_DO_VALE)
			cards_deck.shuffle()
		Opponent:
			card_hand.set_cards_position(card_hand.TOP)
			cards_deck = CardDatabase.get_deck(CardDatabase.DeckType.AMOR)
			cards_deck.shuffle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_card_to_hand(new_card: Card):
	card_hand.add_child(new_card)
	card_hand.update_hand()
	new_card.change_state(Card.states.MoveDrawnCardToHand)
	if player_type == Opponent:
		new_card.hide_card()
		new_card.bottom_card = false
	
func remove_card_from_hand(card: Card):
	card_hand.remove_child(card)
	card_hand.update_hand()
	
