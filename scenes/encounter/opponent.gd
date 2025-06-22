extends Node2D
class_name Opponent

@onready var card_hand: CanvasLayer = $OpponentHand
@onready var opponent_bench: OpponentBench = $OpponentBench
@onready var opponent_field: OpponentField = $OpponentField


var HP = 30
var defense = 0
var mana = 1

var cards_deck = []

var your_turn = false
var index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_hand.set_cards_position(card_hand.TOP)
	
func is_bench_full():
	for card_slot: CardSlot in opponent_bench.card_slots.get_children():
		if card_slot.card == null:
			return false
	return true
	
func is_field_full():
	for card_slot: CardSlot in opponent_field.card_slots.get_children():
		if card_slot.card == null:
			return false
	return true


func add_card_to_hand(card: Card):
	card.hide_card()
	card_hand.add_child(card)
	card_hand.update_hand()
	card.change_state(Card.states.MoveDrawnCardToHand)

func remove_card_from_hand(card: Card):
	card_hand.remove_child(card)
	card_hand.update_hand()
	
func add_card_to_bench(card: Card):
	card.show_card()
	for card_slot: CardSlot in opponent_bench.card_slots.get_children():
		if !card_slot.card:
			card_slot.add_card(card)
			return

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
	
