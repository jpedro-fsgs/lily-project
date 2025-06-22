extends Node2D

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/global/main.tscn")


func _on_amor_button_pressed() -> void:
	EncounterSetup.set_opponent_deck(CardDatabase.DeckType.AMOR)
	var game = load("res://scenes/encounter/encounter_scene.tscn")
	get_tree().change_scene_to_packed(game)


func _on_raiva_button_pressed() -> void:
	var game = load("res://scenes/encounter/encounter_scene.tscn")
	EncounterSetup.set_opponent_deck(CardDatabase.DeckType.RAIVA)
	get_tree().change_scene_to_packed(game)


func _on_tristeza_button_pressed() -> void:
	var game = load("res://scenes/encounter/encounter_scene.tscn")
	EncounterSetup.set_opponent_deck(CardDatabase.DeckType.TRISTEZA)
	get_tree().change_scene_to_packed(game)


func _on_ganancia_button_pressed() -> void:
	var game = load("res://scenes/encounter/encounter_scene.tscn")
	EncounterSetup.set_opponent_deck(CardDatabase.DeckType.GANANCIA)
	get_tree().change_scene_to_packed(game)
