extends Node

var DATA

enum DeckType {
	AMOR,
	PUREZA,
	GANANCIA,
	RAIVA,
	TRISTEZA,
	ESPERANCA
}

func _ready() -> void:
	var file = FileAccess.open("res://data/decks_database.json", FileAccess.READ)
	var content = file.get_as_text()
	DATA = JSON.parse_string(content)
	
func get_deck(deck_type: DeckType):
	var cards = []
	for card in DATA[DeckType.keys()[deck_type]]:
		for i in range(card["copias_permitidas"]):
			cards.append(card.duplicate())
		
	cards.shuffle()
	return cards.slice(0, 30)
	
	
	
var effects = {
	"Eco da Colina Branca": Callable(self, "_effect_eco_da_colina"),
	"Ninho de Beija-flor": Callable(self, "_effect_ninho_de_beija_flor"),
	"Chave de Prata": Callable(self, "_effect_chave_de_prata"),
}

func _effect_eco_da_colina(
		_card: Card,
		_game_state_manager: GameStateManager,
		_card_manager: CardManager
	) -> void:
	_game_state_manager.player_increase_mana(4)

func _effect_ninho_de_beija_flor(
		_card: Card,
		_game_state_manager: GameStateManager,
		_card_manager: CardManager
	) -> void:
	_game_state_manager.opponent_take_damage(2)

func _effect_chave_de_prata(
		_card: Card,
		_game_state_manager: GameStateManager,
		_card_manager: CardManager
	) -> void:
	await get_tree().create_timer(0.25).timeout
	_card_manager.draw_card_player()
	await get_tree().create_timer(0.25).timeout
	_card_manager.draw_card_player()
