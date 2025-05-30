extends Node2D
class_name OpponentBench

@onready var card_slots: Node2D = $CardSlots

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_card(card: Card):
	for card_slot: CardSlot in card_slots.get_children():
		if !card_slot.card:
			card_slot.add_card(card)
			return
