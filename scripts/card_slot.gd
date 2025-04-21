class_name CardSlot
extends Node2D

@onready var card_slot_detector: Area2D = $CardSlotDetector
@onready var cards_in_slot: Node2D = $Cards
@onready var cards_count: Label = $CardsCount

var count = 0

var cards = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_card(card: Card):
	var global_position_card = card.global_position
	
	card.get_parent().get_parent().remove_card_from_hand(card)
	card.z_index = 1
	cards_in_slot.add_child(card)
	cards.append(card)
	count += card._cost
	cards_count.text = str(count)
	card.global_position = global_position_card
	
	card._targetpos = Vector2.ZERO - card.size/2
	card.change_state(Card.states.InSlot)

	
