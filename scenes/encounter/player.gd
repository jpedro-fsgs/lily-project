extends Node2D
class_name Player

@onready var card_hand: Node2D = $PlayerHand
@onready var player_bench: PlayerBench = $PlayerBench
@onready var player_field: PlayerField = $PlayerField
@onready var drop_detector: Area2D = $DropDetector


var HP = 30
var defense = 0
var mana = 1


var your_turn = false
var index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_hand.set_cards_position(card_hand.BOTTOM)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_card_to_hand(card: Card):
	card_hand.add_child(card)
	card_hand.update_hand()
	card.change_state(Card.states.MoveDrawnCardToHand)
	card.change_field(Card.fields.Hand)

func remove_card_from_hand(card: Card):
	card_hand.remove_child(card)
	card_hand.update_hand()
	
func add_card_to_bench(card: Card):
	for card_slot: CardSlot in player_bench.card_slots.get_children():
		if !card_slot.card:
			card_slot.add_card(card)
			return
	card.change_state(Card.states.InBench)
	card.change_field(Card.fields.Bench)

func remove_card_from_bench(card: Card):
	var card_slot: CardSlot = card.card_slot
	card_slot.remove_card(card)
	
func add_card_to_field(card: Card):
	for card_slot: CardSlot in player_field.card_slots.get_children():
		if !card_slot.card:
			card_slot.add_card(card)
			return
	card.change_state(Card.states.InField)
	card.change_field(Card.fields.Combat)

func remove_card_from_field(card: Card):
	pass
	
func receive_damage(dmg: int):
	HP -= dmg
	emit_signal("update_hp", HP)
	
func add_defense(def: int):
	defense += def
