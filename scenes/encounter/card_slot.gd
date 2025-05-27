extends Node2D
class_name CardSlot

@onready var card_slot_detector: Area2D = $CardSlotDetector
@onready var card_in_slot: Node2D = $CardInSlot

var card: Card = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_card(new_card: Card):
	
	card = new_card
	var global_position_card = card.global_position
	
	new_card.get_parent().remove_child(card)
	card_in_slot.add_child(new_card)
	new_card.z_index = 1
	new_card.show_card()

	new_card.global_position = global_position_card
	
	new_card._targetpos = Vector2.ZERO - card.size/2
	new_card.change_state(Card.states.InSlot)

	
