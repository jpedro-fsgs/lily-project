extends Node2D
class_name OpponentAIManager

@onready var game_state_manager: GameStateManager = $"../GameStateManager"

@onready var player_card_hand: Node2D = $"../Players/Player/PlayerHand"
@onready var player_field: PlayerField = $"../Players/Player/PlayerField"
@onready var player_bench: PlayerBench = $"../Players/Player/PlayerBench"

@onready var opponent_card_hand: Node2D = $"../Players/Opponent/OpponentHand"
@onready var opponent_field: OpponentField = $"../Players/Opponent/OpponentField"
@onready var opponent_bench: OpponentBench = $"../Players/Opponent/OpponentBench"

@onready var player: Player = $"../Players/Player"
@onready var opponent: Opponent = $"../Players/Opponent"

var can_buy_cards = []
var can_play_cards = []


func update_available_cards():
	can_buy_cards.clear()
	can_play_cards.clear()
	
	for card in opponent_card_hand.get_children():
		print(game_state_manager.opponent_mana)
		if game_state_manager.opponent_mana > card._cost:
			var play = Callable(game_state_manager, "opponent_buy_card")
			can_buy_cards.append({
				"card": card,
				"play": play
			})
	for slot in opponent_bench.card_slots.get_children():
		var card = slot.card
		if card:
			var play = Callable(game_state_manager, "opponent_play_card")
			can_play_cards.append({
				"card": card,
				"play": play
			})

func exec_random_play(plays: Array):
	if plays:
		var play = plays[randi() % plays.size()]
		play["play"].call(play["card"])

func _on_game_state_manager_opponent_turn() -> void:
	update_available_cards()
	await get_tree().create_timer(1).timeout
	if can_play_cards:
		exec_random_play(can_play_cards)
		return
	if can_buy_cards:
		exec_random_play(can_buy_cards)
		return
