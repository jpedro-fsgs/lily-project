extends Node

const levels = [
	CardDatabase.DeckType.AMOR,
	CardDatabase.DeckType.TRISTEZA,
	CardDatabase.DeckType.ESPERANCA,
	CardDatabase.DeckType.GANANCIA,
	CardDatabase.DeckType.RAIVA,
]

var level_index = 1
var current_jardim = "Jardim do Amor"

@onready var current_player_deck = CardDatabase.get_deck(CardDatabase.DeckType.PUREZA)
@onready var current_opponent_deck = CardDatabase.get_deck(CardDatabase.DeckType.AMOR)

func next_level():
	if level_index >= levels.size():
		return
	level_index += 1

func update_jardim(opponent_deck: CardDatabase.DeckType):
	print_debug("update")
	match opponent_deck:
		CardDatabase.DeckType.AMOR:
			current_jardim = "Jardim do Amor"
		CardDatabase.DeckType.TRISTEZA:
			current_jardim = "Jardim da Tristeza"
		CardDatabase.DeckType.ESPERANCA:
			current_jardim = "Jardim do Esperança"
		CardDatabase.DeckType.GANANCIA:
			current_jardim = "Jardim do Ganância"
		CardDatabase.DeckType.RAIVA:
			current_jardim = "Jardim da Raiva"
	print_debug(current_jardim)

func set_player_deck(deck_type: CardDatabase.DeckType):
	current_player_deck = CardDatabase.get_deck(deck_type)

func set_opponent_deck(deck_type: CardDatabase.DeckType):
	print_debug(deck_type)
	current_opponent_deck = CardDatabase.get_deck(deck_type)
	update_jardim(deck_type)
	
func get_player_deck():
	return current_player_deck.duplicate()
	
func get_opponent_deck():
	return current_opponent_deck.duplicate()
