extends Node2D
class_name Player

@onready var card_hand: CanvasLayer = $PlayerHand
@onready var player_bench: PlayerBench = $PlayerBench
@onready var player_field: PlayerField = $PlayerField


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_hand.set_cards_position(card_hand.BOTTOM)

	
func is_bench_full():
	for card_slot: CardSlot in player_bench.card_slots.get_children():
		if card_slot.card == null:
			return false
	return true
	
func is_field_full():
	for card_slot: CardSlot in player_field.card_slots.get_children():
		if card_slot.card == null:
			return false
	return true

func add_card_to_hand(card: Card):
	var global_pos = card.global_position
	card_hand.add_child(card)
	card.global_position = global_pos
	card_hand.update_hand()
	card.change_state(Card.states.MoveDrawnCardToHand)
	card.change_field(Card.fields.Hand)

func remove_card_from_hand(card: Card):
	card_hand.remove_child(card)
	card_hand.update_hand()
	
func add_card_to_bench(card: Card):
	for card_slot: CardSlot in player_bench.card_slots.get_children():
		if !card_slot.card:
			var global_pos = card.global_position
			card_slot.add_card(card)
			card.global_position = global_pos
			return
	card.change_state(Card.states.InBench)
	card.change_field(Card.fields.Bench)

func remove_card_from_bench(card: Card):
	var card_slot: CardSlot = card.card_slot
	card_slot.remove_card(card)
	
func add_card_to_field(card: Card, target_card_slot: CardSlot=null):
	if target_card_slot:

		target_card_slot.add_card(card)
		card.change_state(Card.states.InField)
		card.change_field(Card.fields.Combat)

func remove_card_from_field(card: Card):
	var card_slot: CardSlot = card.card_slot
	card_slot.remove_card(card)
