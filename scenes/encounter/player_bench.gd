extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_card(card: Card):
	
	
	card.get_parent().get_parent().remove_card_from_hand(card)
	card.z_index = 1
	card.show_card()
	#card_container.add_child(card)
	
	card._targetpos = Vector2.ZERO - card.size/2
	card.change_state(Card.states.InSlot)
