extends Node2D

const CARD = preload("res://scenes/card.tscn")
@onready var players: Node2D = $Players
@onready var cards: Node2D = $Cards

var cards_deck = []

@onready var CentreCardOval =  Vector2(get_viewport().size.x * 0.5, get_viewport().size.y * 0.9)
@onready var Hor_rad = get_viewport().size.x * 0.45
@onready var Ver_rad = get_viewport().size.y * 0.15
var angle = deg_to_rad(90)
var OvalAngleVector: Vector2

func _ready() -> void:
	for card in CardDatabase.DATA:
		var new_card = CARD.instantiate()
		new_card.set_attributes(card)
		cards_deck.append(new_card)
	
	cards_deck.shuffle()
	
	#for player in players.get_children():
		#for i in range(5):
			#draw_card(player)
		

func draw_card():
	if cards_deck.size() > 0:
		var card = cards_deck.pop_at(0)
		OvalAngleVector = Vector2(Hor_rad * cos(angle), -Ver_rad * sin(angle))
		card.scale = Vector2(0.5, 0.5)
		card.position = CentreCardOval + OvalAngleVector - card.size/2
		card.rotation = -sin(angle) * 0.5/4
		self.add_child(card)
		angle += deg_to_rad(10)
		

func draw_card_to_player(player):
	if cards.size() > 0:
		var card = cards.pop_at(0)
		player.add_card(card)
		
func return_card():
	if cards.size() > 0:
		var card = cards.pop_at(0)
		return card
		

#func _input(event):
	#if event is InputEventMouseButton and event.pressed:
		##draw_card(players.get_children()[0])
		#var card = cards.pop_at(0)
		#card.position = get_global_mouse_position()
		#self.add_child(card)
