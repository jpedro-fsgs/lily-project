extends Node2D

@onready var amor_button: Button = $MapaJardim2/AmorButton
@onready var tristeza_button: Button = $MapaJardim2/TristezaButton
@onready var esperanca_button: Button = $MapaJardim2/EsperancaButton
@onready var ganancia_button: Button = $MapaJardim2/GananciaButton
@onready var raiva_button: Button = $MapaJardim2/RaivaButton

func _ready() -> void:
	update_buttons()

func update_buttons():
	amor_button.disabled = not EncounterSetup.levels[CardDatabase.DeckType.AMOR]
	tristeza_button.disabled = not EncounterSetup.levels[CardDatabase.DeckType.TRISTEZA]
	esperanca_button.disabled = not EncounterSetup.levels[CardDatabase.DeckType.ESPERANCA]
	ganancia_button.disabled = not EncounterSetup.levels[CardDatabase.DeckType.GANANCIA]
	raiva_button.disabled = not EncounterSetup.levels[CardDatabase.DeckType.RAIVA]

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/global/main.tscn")

func _on_amor_button_pressed() -> void:
	EncounterSetup.set_opponent_deck(CardDatabase.DeckType.AMOR)
	var game = load("res://scenes/encounter/encounter_scene.tscn")
	get_tree().change_scene_to_packed(game)


func _on_raiva_button_pressed() -> void:
	EncounterSetup.set_opponent_deck(CardDatabase.DeckType.RAIVA)
	var game = load("res://scenes/encounter/encounter_scene.tscn")
	get_tree().change_scene_to_packed(game)


func _on_tristeza_button_pressed() -> void:
	EncounterSetup.set_opponent_deck(CardDatabase.DeckType.TRISTEZA)
	var game = load("res://scenes/encounter/encounter_scene.tscn")
	get_tree().change_scene_to_packed(game)


func _on_ganancia_button_pressed() -> void:
	EncounterSetup.set_opponent_deck(CardDatabase.DeckType.GANANCIA)
	var game = load("res://scenes/encounter/encounter_scene.tscn")
	get_tree().change_scene_to_packed(game)


func _on_esperanca_button_pressed() -> void:
	EncounterSetup.set_opponent_deck(CardDatabase.DeckType.ESPERANCA)
	var game = load("res://scenes/encounter/encounter_scene.tscn")
	get_tree().change_scene_to_packed(game)
