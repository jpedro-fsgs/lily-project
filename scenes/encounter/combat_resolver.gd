extends Node2D
class_name CombatResolver

@onready var game_state_manager: GameStateManager = $"../GameStateManager"


@onready var player_field: PlayerField = $"../Players/Player/PlayerField"
@onready var opponent_field: OpponentField = $"../Players/Opponent/OpponentField"

@onready var player_card_slot: CardSlot = $"../Players/Player/PlayerField/CardSlots/CardSlot"
@onready var player_card_slot_2: CardSlot = $"../Players/Player/PlayerField/CardSlots/CardSlot2"
@onready var player_card_slot_3: CardSlot = $"../Players/Player/PlayerField/CardSlots/CardSlot3"
@onready var player_card_slot_4: CardSlot = $"../Players/Player/PlayerField/CardSlots/CardSlot4"
@onready var player_card_slot_5: CardSlot = $"../Players/Player/PlayerField/CardSlots/CardSlot5"
@onready var player_card_slot_6: CardSlot = $"../Players/Player/PlayerField/CardSlots/CardSlot6"

@onready var opponent_card_slot: CardSlot = $"../Players/Opponent/OpponentField/CardSlots/CardSlot"
@onready var opponent_card_slot_2: CardSlot = $"../Players/Opponent/OpponentField/CardSlots/CardSlot2"
@onready var opponent_card_slot_3: CardSlot = $"../Players/Opponent/OpponentField/CardSlots/CardSlot3"
@onready var opponent_card_slot_4: CardSlot = $"../Players/Opponent/OpponentField/CardSlots/CardSlot4"
@onready var opponent_card_slot_5: CardSlot = $"../Players/Opponent/OpponentField/CardSlots/CardSlot5"
@onready var opponent_card_slot_6: CardSlot = $"../Players/Opponent/OpponentField/CardSlots/CardSlot6"



@onready var eq_field = {
		player_card_slot: opponent_card_slot,
		player_card_slot_2: opponent_card_slot_2,
		player_card_slot_3: opponent_card_slot_3,
		player_card_slot_4: opponent_card_slot_4,
		player_card_slot_5: opponent_card_slot_5,
		player_card_slot_6: opponent_card_slot_6,
	}

@onready var field = [
	{
		"player_side": player_card_slot,
		"opponent_side": opponent_card_slot
	},
	{
		"player_side": player_card_slot_2,
		"opponent_side": opponent_card_slot_2
	},
	{
		"player_side": player_card_slot_3,
		"opponent_side": opponent_card_slot_3
	},
	{
		"player_side": player_card_slot_4,
		"opponent_side": opponent_card_slot_4
	},
	{
		"player_side": player_card_slot_5,
		"opponent_side": opponent_card_slot_5
	},
	{
		"player_side": player_card_slot_6,
		"opponent_side": opponent_card_slot_6
	},
]

var start_combat := false


#func _process(delta: float) -> void:
	#pass
	
	
func has_card_on_field():
	for slot in player_field.card_slots.get_children():
		if slot.card:
			return true
	for slot in opponent_field.card_slots.get_children():
		if slot.card:
			return true
			
func player_has_card_on_field():
	for slot in player_field.card_slots.get_children():
		if slot.card:
			return true

func resolve_combat():
	for f in field:
		var player_card = f["player_side"].card
		var opponent_card = f["opponent_side"].card
		#await get_tree().create_timer(0.5).timeout
		if player_card and opponent_card:
			await opponent_card.attack_animation()
			player_card.receive_damage(opponent_card._attack)
			if opponent_card._attack > 0:
				await player_card.damage_animation()
			#await get_tree().create_timer(0.25).timeout
			await player_card.attack_animation()
			opponent_card.receive_damage(player_card._attack)
			if player_card._attack > 0:
				await opponent_card.damage_animation()
			
		else:
			if player_card:
				await player_card.attack_animation()
				game_state_manager.opponent_take_damage(player_card._attack)
			if opponent_card:
				await opponent_card.attack_animation()
				game_state_manager.player_take_damage(opponent_card._attack)
		if player_card:
			await player_card.check_health()
		if opponent_card:
			await opponent_card.check_health()
				
	game_state_manager.cards_back_on_bench()
