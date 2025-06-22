extends Node2D
class_name PlayerBench

@onready var card_slots: Node2D = $CardSlots

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for card_slot: CardSlot in card_slots.get_children():
		card_slot.set_bench_slot()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
