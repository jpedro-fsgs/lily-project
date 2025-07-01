extends Node2D
class_name OpponentField

@onready var card_slots: Node2D = $CardSlots

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for card_slot: CardSlot in card_slots.get_children():
		card_slot.set_field_slot()
		card_slot.set_opponent_slot()

func add_card(card: Card):
	
	card.get_parent().remove_child(card)
	card.z_index = 1
	card.show_card()
	
	for card_slot in card_slots.get_children():
		if card_slot.card == null:
			card_slot.add_card(card)
	
	card._targetpos = Vector2.ZERO - card.size/2
	card.change_state(Card.states.InBench)
