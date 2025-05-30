extends Node

#@onready var current_player_deck = CardDatabase.get_deck(CardDatabase.DeckType.PUREZA)
#@onready var current_opponent_deck = CardDatabase.get_deck(CardDatabase.DeckType.RAIVA)
@onready var current_player_deck = CardDatabase.get_deck(CardDatabase.DeckType.PUREZA)
@onready var current_opponent_deck = CardDatabase.get_deck(CardDatabase.DeckType.AMOR)

func set_player_deck(deck_type: CardDatabase.DeckType):
	current_player_deck = CardDatabase.get_deck(deck_type)

func set_opponent_deck(deck_type: CardDatabase.DeckType):
	current_opponent_deck = CardDatabase.get_deck(deck_type)
	
func get_player_deck():
	return current_player_deck.duplicate()
	
func get_opponent_deck():
	return current_opponent_deck.duplicate()
