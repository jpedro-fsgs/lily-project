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
	
func get_deck(deck: DeckType):
	return DATA[DeckType.keys()[deck]].duplicate()
