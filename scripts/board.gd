extends Node2D

const CARD = preload("res://scenes/card.tscn")
@onready var players: Node2D = $Players

var cards = []

func _ready() -> void:
	for card in CardDatabase.DATA:
		var new_card = CARD.instantiate()
		new_card.set_attributes(card)
		cards.append(new_card)
	
	cards.shuffle()
	
	for player in players.get_children():
		for i in range(5):
			player.add_card(draw_card())
		

func draw_card():
	if cards.size() > 0:
		var card = cards.pop_at(0)
		return card
