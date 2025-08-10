extends Node

var levels = {
	CardDatabase.DeckType.AMOR: true,
	CardDatabase.DeckType.TRISTEZA: false,
	CardDatabase.DeckType.ESPERANCA: false,
	CardDatabase.DeckType.GANANCIA: false,
	CardDatabase.DeckType.RAIVA: false,
	"endgame": false
}

var current_jardim = "Jardim do Amor"
var current_decktype: CardDatabase.DeckType

@onready var current_player_deck = CardDatabase.get_deck(CardDatabase.DeckType.PUREZA)
@onready var current_opponent_deck = CardDatabase.get_deck(CardDatabase.DeckType.AMOR)

func is_endgame():
	return current_decktype == CardDatabase.DeckType.RAIVA and levels["endgame"]

func next_level():
	match current_decktype:
		CardDatabase.DeckType.AMOR:
			levels[CardDatabase.DeckType.TRISTEZA] = true
		CardDatabase.DeckType.TRISTEZA:
			levels[CardDatabase.DeckType.ESPERANCA] = true
		CardDatabase.DeckType.ESPERANCA:
			levels[CardDatabase.DeckType.GANANCIA] = true
		CardDatabase.DeckType.GANANCIA:
			levels[CardDatabase.DeckType.RAIVA] = true
		CardDatabase.DeckType.RAIVA:
			levels["endgame"] = true

func update_jardim(opponent_deck: CardDatabase.DeckType):
	match opponent_deck:
		CardDatabase.DeckType.AMOR:
			current_jardim = "Jardim do Amor"
		CardDatabase.DeckType.TRISTEZA:
			current_jardim = "Jardim da Tristeza"
		CardDatabase.DeckType.ESPERANCA:
			current_jardim = "Jardim da Esperança"
		CardDatabase.DeckType.GANANCIA:
			current_jardim = "Jardim da Ganância"
		CardDatabase.DeckType.RAIVA:
			current_jardim = "Jardim da Raiva"

func set_player_deck(deck_type: CardDatabase.DeckType):
	current_player_deck = CardDatabase.get_deck(deck_type)

func set_opponent_deck(deck_type: CardDatabase.DeckType):
	current_opponent_deck = CardDatabase.get_deck(deck_type)
	current_decktype = deck_type
	update_jardim(deck_type)
	
func get_player_deck():
	return current_player_deck.duplicate()
	
func get_opponent_deck():
	return current_opponent_deck.duplicate()
