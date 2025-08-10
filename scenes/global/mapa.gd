extends Node2D

@onready var amor_button: Button = $MapaJardim2/AmorButton
@onready var tristeza_button: Button = $MapaJardim2/TristezaButton
@onready var esperanca_button: Button = $MapaJardim2/EsperancaButton
@onready var ganancia_button: Button = $MapaJardim2/GananciaButton
@onready var raiva_button: Button = $MapaJardim2/RaivaButton

func _ready() -> void:
	update_buttons()

func update_buttons():
	tristeza_button.disabled = EncounterSetup.level_index < 1
	esperanca_button.disabled = EncounterSetup.level_index < 2
	ganancia_button.disabled = EncounterSetup.level_index < 3
	raiva_button.disabled = EncounterSetup.level_index < 4

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
