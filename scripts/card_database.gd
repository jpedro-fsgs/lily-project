extends Node

var cards_database

func load_cards_database():
	var file = FileAccess.open("res://data/cards_database.json", FileAccess.READ)
	var content = file.get_as_text()
	return JSON.parse_string(content)
	
func _ready() -> void:
	cards_database = load_cards_database()
