extends Node

var DATA

enum DeckType {
	AMOR,
	LIRIO_DO_VALE,
	GANANCIA,
	LIRIO_ARANHA,
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
		
	if not cards:
		print("cards")
	return cards
