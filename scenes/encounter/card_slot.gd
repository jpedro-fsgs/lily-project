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
	card.card_slot = self
	var global_pos = card.global_position
	card_in_slot.add_child(new_card)
	card.global_position = global_pos
	new_card.z_index = 1
	new_card.show_card()
	
	new_card._targetpos = Vector2.ZERO - card.size/2
	new_card.change_state(Card.states.InBench)
	new_card.change_field(Card.fields.Bench)

func remove_card(new_card: Card):
	new_card.card_slot = null
	card = null
	card_in_slot.remove_child(new_card)
