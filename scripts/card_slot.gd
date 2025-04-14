extends Node2D

var cards = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_card(card):
	card.get_parent().remove_child(card)
	add_child(card)
	cards.append(card)
	card.change_state(Card.InSlot)
	card._targetpos = Vector2.ZERO - card.size/2
	
