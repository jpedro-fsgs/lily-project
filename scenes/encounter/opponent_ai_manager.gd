extends Node2D
class_name OpponentAIManager

@onready var game_state_manager: GameStateManager = $"../GameStateManager"

@onready var player_card_hand: CanvasLayer = $"../Players/Player/PlayerHand"
@onready var player_field: PlayerField = $"../Players/Player/PlayerField"
@onready var player_bench: PlayerBench = $"../Players/Player/PlayerBench"

@onready var opponent_card_hand: CanvasLayer = $"../Players/Opponent/OpponentHand"
@onready var opponent_field: OpponentField = $"../Players/Opponent/OpponentField"
@onready var opponent_bench: OpponentBench = $"../Players/Opponent/OpponentBench"

@onready var player: Player = $"../Players/Player"
@onready var opponent: Opponent = $"../Players/Opponent"



func get_game_snapshot():
	pass
	

func update_available_cards():
	var available_plays = []
	var available_card_slots = []
	
	for card_slot in opponent_field.card_slots.get_children():
		if not card_slot.card:
			available_card_slots.append(card_slot)
	
	available_plays.append({
				"card": null,
				"card_slot": null,
				"play": Callable(game_state_manager, "end_turn")
			})
	
	for card in opponent_card_hand.get_children():
		if game_state_manager.opponent_buy_card(card, true):
			available_plays.append({
				"card": card,
				"card_slot": null,
				"play": Callable(game_state_manager, "opponent_buy_card")
			})
	for slot in opponent_bench.card_slots.get_children():
		var card = slot.card
		if card and game_state_manager.opponent_play_card(card, true):
			for card_slot in available_card_slots:
				available_plays.append({
					"card": card,
					"card_slot": card_slot,
					"play": Callable(game_state_manager, "opponent_play_card")
				})
			
	for slot in opponent_field.card_slots.get_children():
		var card = slot.card
		if card and game_state_manager.opponent_play_card(card, true):
			available_plays.append({
				"card": card,
				"card_slot": null,
				"play": Callable(game_state_manager, "opponent_reallocate_card")
			})
			
	return available_plays

func exec_random_play(plays: Array):
	if plays:
		var i = randi() % plays.size()
		var play = plays[i]
		exec_play(play)
		
func exec_play(play):
	if play["card"]:
		if play["card_slot"]:
			play["play"].call(play["card"], false, play["card_slot"])
			return
		play["play"].call(play["card"])
		
		return
	play["play"].call()


func next_play() -> void:
	var available_plays = update_available_cards()
	await get_tree().create_timer(1).timeout
	exec_random_play(available_plays)
