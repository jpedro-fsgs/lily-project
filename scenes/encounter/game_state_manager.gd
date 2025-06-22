extends Node2D
class_name GameStateManager

@onready var endgame_dialog: EndgameDialog = $"../EndgameDialog"


@onready var card_manager: CardManager = $"../CardManager"
@onready var combat_resolver: CombatResolver = $"../CombatResolver"
@onready var tutorial_manager: TutorialManager = $"../TutorialManager"

@onready var opponent_ai_manager: OpponentAIManager = $"../OpponentAIManager"

@onready var player: Player = $"../Players/Player"
@onready var player_bench: PlayerBench = $"../Players/Player/PlayerBench"
@onready var player_field: PlayerField = $"../Players/Player/PlayerField"

@onready var opponent: Opponent = $"../Players/Opponent"
@onready var opponent_bench: OpponentBench = $"../Players/Opponent/OpponentBench"
@onready var opponent_field: OpponentField = $"../Players/Opponent/OpponentField"

@onready var background: Sprite2D = $"../Background"
@onready var ui: CanvasLayer = $"../UI"

const ENDGAME_DIALOG: PackedScene = preload("res://scenes/encounter/endgame_dialog.tscn")



enum players {
	PLAYER,
	OPPONENT
}

var player_hp: int = 15
var player_mana: int = 5


var opponent_hp: int = 15
var opponent_mana: int = 5

var base_mana = 1


signal round_changed(round: int)
signal turn_changed(turn_player: players)
signal attack_token_changed(attack_token_player: players)

var current_turn_player: players = players.PLAYER 
var current_round: int = 1                 
var has_attack_token: players = players.PLAYER
var attack_started := false

var number_of_plays_last_turn_player := 0
var number_of_plays_last_turn_opponent := 0
var is_first_turn := true
var attack_answered := false
var attack_done := false

var live_game := true


signal player_hp_changed(new_hp: int)
signal player_mana_changed(new_mana: int)
signal opponent_hp_changed(new_hp: int)
signal opponent_mana_changed(new_mana: int)

func _ready():
	initialize_game_attributes()

func initialize_game_attributes():
	await $"../UI".ready
	set_player_hp(player_hp)
	set_player_mana(player_mana)
	
	set_opponent_hp(opponent_hp)
	set_opponent_mana(opponent_mana)
	
	initial_cards()

func initial_cards():
	for i in range(4):
		await get_tree().create_timer(0.25).timeout
		card_manager.draw_card_player()
		await get_tree().create_timer(0.25).timeout
		card_manager.draw_card_opponent()
	
	# Tutorial 1
	await tutorial_manager.next_dialog(1)
		
func next_round():
	if not live_game:
		return
	await tutorial_manager.next_dialog(6)
	current_round += 1
	
	set_player_mana(player_mana + base_mana)
	set_opponent_mana(opponent_mana + base_mana)
	base_mana += 1
	await get_tree().create_timer(0.25).timeout
	card_manager.draw_card_player()
	await get_tree().create_timer(0.25).timeout
	card_manager.draw_card_opponent()
	emit_signal("round_changed", current_round)
	current_turn_player = players.PLAYER
	emit_signal("turn_changed", current_turn_player)
	has_attack_token = (
		players.PLAYER 
		if has_attack_token == players.OPPONENT 
		else players.OPPONENT
		)
	attack_started = false
	attack_done = false
	emit_signal("attack_token_changed", has_attack_token)
	
func end_turn():
	if not live_game:
		return
	
	if combat_resolver.has_card_on_field():
		if current_turn_player != has_attack_token:
			# Tutorial 4
			await tutorial_manager.next_dialog(4)
			await combat_resolver.resolve_combat()
			await tutorial_manager.next_dialog(5)
			attack_done = true
	
	var should_go_to_next_round := (
		number_of_plays_last_turn_opponent == 0 and
		number_of_plays_last_turn_player == 0 and
		not is_first_turn
	)
	if should_go_to_next_round:
		number_of_plays_last_turn_opponent = 0
		number_of_plays_last_turn_player = 0
		is_first_turn = true
		attack_answered = false
		next_round()
		
	else:
		is_first_turn = false
		match current_turn_player:
			players.PLAYER:
				number_of_plays_last_turn_opponent = 0
				current_turn_player = players.OPPONENT
				opponent_ai_manager.next_play()
			players.OPPONENT:
				number_of_plays_last_turn_player = 0
				current_turn_player = players.PLAYER
		
	emit_signal("turn_changed", current_turn_player)
	
func blur_background():
	var tween = create_tween()
	tween.tween_method(
		(func(value):
			background.material.set_shader_parameter("radius", value)),
			0, 4.0, 2
			)
	await tween.finished

func check_win():
	if player_hp > 0 and opponent_hp > 0:
		return
	
	if player_hp <=0:
		endgame_dialog.set_winner("DERROTA")
		
	elif opponent_hp <= 0:
		endgame_dialog.set_winner("VITÓRIA")
	
	endgame_dialog.visible = true
	blur_background()
	live_game = false
	

func is_player_turn():
	return current_turn_player == players.PLAYER
	
func is_opponent_turn():
	return current_turn_player == players.OPPONENT
	
	
# --- Setter Functions for HP ---
func set_player_hp(new_value: int) -> void:
	player_hp = new_value if new_value > 0 else 0
	emit_signal("player_hp_changed", player_hp)
	check_win()

func set_opponent_hp(new_value: int) -> void:
	opponent_hp = new_value if new_value > 0 else 0
	emit_signal("opponent_hp_changed", opponent_hp)
	check_win()

# --- Setter Functions for Mana ---
func set_player_mana(new_value: int) -> void:
	player_mana = new_value
	emit_signal("player_mana_changed", player_mana)

func set_opponent_mana(new_value: int) -> void:
	opponent_mana = new_value
	emit_signal("opponent_mana_changed", opponent_mana)
	
func player_increase_mana(added_mana: int) -> void:
	set_player_mana(player_mana + added_mana)
	
func opponent_increase_mana(added_mana: int) -> void:
	set_opponent_mana(opponent_mana + added_mana)
	
func player_increase_hp(added_hp: int) -> void:
	set_player_hp(player_hp + added_hp)
	
func opponent_increase_hp(added_hp: int) -> void:
	set_opponent_hp(opponent_hp + added_hp)

func player_take_damage(dmg: int):
	set_player_hp(player_hp - dmg)
	if dmg > 0:
		ui.player_damage()
	
func opponent_take_damage(dmg: int):
	set_opponent_hp(opponent_hp - dmg)
	if dmg > 0:
		ui.opponent_damage()
	
func player_field_cards_increase_attributes(add_attack: int, add_defense: int):
	for card_slot in player_field.card_slots.get_children():
		var card: Card = card_slot.card
		if card and not card._effect_applied:
			card.add_attack(add_attack)
			card.add_defense(add_defense)
			card._effect_applied = true
		
	

func opponent_buy_card(card: Card, check: bool=false):
	if not live_game or opponent.is_bench_full():
		return
	if not is_opponent_turn() or opponent_mana < card._cost:
		return false
	if check:
		return true
		
	set_opponent_mana(opponent_mana - card._cost)
	opponent.remove_card_from_hand(card)
	opponent.add_card_to_bench(card)
	card.change_state(Card.states.InBench)
	
	number_of_plays_last_turn_opponent +=1
	
	opponent_ai_manager.next_play()
	return true
	
	
func player_buy_card(card: Card, check: bool=false):
	if not live_game or player.is_bench_full():
		return
	# Tutorial 2
	tutorial_manager.next_dialog(2)
	if not is_player_turn() or player_mana < card._cost:
		return false
	if check:
		return true
	set_player_mana(player_mana - card._cost)
	

	player.remove_card_from_hand(card)
	player.add_card_to_bench(card)
	number_of_plays_last_turn_player +=1
	
	if card._apply_effect:
		var effect = CardDatabase.effects[card._name]
		effect.call(card, self, card_manager)
	
	return true
	
func opponent_play_card(card: Card, check: bool=false, card_slot: CardSlot=null):
	if not live_game:
		return
	var can_play: = (
		card.field == Card.fields.Bench
		and is_opponent_turn()
		and not attack_done
		and (
			has_attack_token == players.OPPONENT
			or attack_started
			)
		)
	if not can_play:
		return false
	if check:
		return true
	opponent.remove_card_from_bench(card)
	opponent.add_card_to_field(card, card_slot)
	
	attack_started = true
	number_of_plays_last_turn_opponent += 1
	
	opponent_ai_manager.next_play()
	return true
	
func player_play_card(card: Card, check: bool=false, card_slot: CardSlot=null):
	if not live_game:
		return
	var can_play: = (
		card.field != Card.fields.Hand
		and is_player_turn()
		and not attack_done
		and (
			has_attack_token == players.PLAYER
			or attack_started
			)
		)
	if not can_play:
		return false
	if check:
		return true
		
	player.remove_card_from_bench(card)
	player.add_card_to_field(card, card_slot)
	
	attack_started = true
	number_of_plays_last_turn_player += 1
	# Tutorial 3
	tutorial_manager.next_dialog(3)
	
	if card._apply_effect:
		var effect = CardDatabase.effects[card._name]
		effect.call(card, self, card_manager)
	return true
	
func opponent_reallocate_card(card: Card, check: bool=false, card_slot: CardSlot=null):
	if not live_game:
		return
	var can_play: = (
		card.field == Card.fields.Combat
		and is_opponent_turn()
		and (
			has_attack_token == players.OPPONENT
			or attack_started
			)
		)
	if not can_play:
		return false
	if check:
		return true
		
	opponent.remove_card_from_field(card)
	opponent.add_card_to_field(card, card_slot)
	
	attack_started = true
	number_of_plays_last_turn_opponent += 1
	
	opponent_ai_manager.next_play()
	return true
	
func player_reallocate_card(card: Card, check: bool=false, card_slot: CardSlot=null):
	if not live_game:
		return
	var can_play: = (
		card.field == Card.fields.Combat
		and is_player_turn()
		and (
			has_attack_token == players.PLAYER
			or attack_started
			)
		)
	if not can_play:
		return false
	if check:
		return true
		
	player.remove_card_from_field(card)
	player.add_card_to_field(card, card_slot)
	
	attack_started = true
	number_of_plays_last_turn_player += 1
	return true

func cards_back_on_bench():
	if not live_game:
		return
	for card_slot in player_field.card_slots.get_children():
		if card_slot.card:
			var card = card_slot.card
			player.remove_card_from_field(card)
			player.add_card_to_bench(card)
	
	for card_slot in opponent_field.card_slots.get_children():
		if card_slot.card:
			var card = card_slot.card
			opponent.remove_card_from_field(card)
			opponent.add_card_to_bench(card)


func _on_action_button_pressed() -> void:
	if not live_game:
		return
	match current_turn_player:
		players.PLAYER:
			end_turn()
