extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	EncounterSetup.set_opponent_deck(CardDatabase.DeckType.AMOR)
	var game = load("res://scenes/encounter/encounter_scene.tscn")
	get_tree().change_scene_to_packed(game)


func _on_button_2_pressed() -> void:
	var game = load("res://scenes/encounter/encounter_scene.tscn")
	EncounterSetup.set_opponent_deck(CardDatabase.DeckType.RAIVA)
	get_tree().change_scene_to_packed(game)

func _on_button_3_pressed() -> void:
	var game = load("res://scenes/encounter/encounter_scene.tscn")
	EncounterSetup.set_opponent_deck(CardDatabase.DeckType.TRISTEZA)
	get_tree().change_scene_to_packed(game)

func _on_button_4_pressed() -> void:
	var game = load("res://scenes/encounter/encounter_scene.tscn")
	EncounterSetup.set_opponent_deck(CardDatabase.DeckType.GANANCIA)
	get_tree().change_scene_to_packed(game)
