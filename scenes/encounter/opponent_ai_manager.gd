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

var can_buy_cards = []
var can_play_cards = []
var available_plays = []

func update_available_cards():
	can_buy_cards.clear()
	can_play_cards.clear()
	available_plays.clear()
	available_plays.append({
				"card": null,
				"play": Callable(game_state_manager, "end_turn")
			})
	
	for card in opponent_card_hand.get_children():
		if game_state_manager.opponent_buy_card(card, true):
			available_plays.append({
				"card": card,
				"play": Callable(game_state_manager, "opponent_buy_card")
			})
	for slot in opponent_bench.card_slots.get_children():
		var card = slot.card
		if card:
			var play = Callable(game_state_manager, "opponent_play_card")
			available_plays.append({
				"card": card,
				"play": play
			})

func exec_random_play(plays: Array):
	if plays:
		var play = plays[randi() % plays.size()]
		exec_play(play)
		
func exec_play(play):
	if play["card"]:
		play["play"].call(play["card"])
		return
	play["play"].call()


func next_play() -> void:
	update_available_cards()
	await get_tree().create_timer(1).timeout
	exec_random_play(available_plays)


#func _on_game_state_manager_turn_changed(turn_player: GameStateManager.players) -> void:
	#update_available_cards()
	#await get_tree().create_timer(1).timeout
	#exec_random_play(available_plays)
