extends Node2D
class_name GameStateManager

@onready var card_manager: CardManager = $"../CardManager"
@onready var opponent_ai_manager: OpponentAIManager = $"../OpponentAIManager"

@onready var player: Player = $"../Players/Player"
@onready var player_bench: PlayerBench = $"../Players/Player/PlayerBench"
@onready var player_field: PlayerField = $"../Players/Player/PlayerField"

@onready var opponent: Opponent = $"../Players/Opponent"
@onready var opponent_bench: OpponentBench = $"../Players/Opponent/OpponentBench"
@onready var opponent_field: OpponentField = $"../Players/Opponent/OpponentField"


enum players {
	PLAYER,
	OPPONENT
}

# --- Atributos do Jogador Humano ---
var player_hp: int = 30  # HP atual do Nexus do jogador
var player_max_hp: int = 30      # HP máximo do Nexus do jogador
var player_mana: int = 15  # Mana de ação disponível neste turno

# --- Atributos do Oponente (IA) ---
var opponent_hp: int = 30
var opponent_max_hp: int = 30
var opponent_mana: int = 15

var base_mana = 1

# Outras variáveis de estado importantes gerenciadas aqui:
signal round_changed(round: int)
signal turn_changed(turn_player: players)

var current_turn_player: players = players.PLAYER # Quem tem o turno ("Player" ou "Opponent")
var current_round: int = 1                 # Rodada atual do jogo
var has_attack_token: players = players.PLAYER   # Quem tem a permissão para iniciar um ataque

var number_of_plays_last_turn_player = 0
var number_of_plays_last_turn_opponent = 0
var is_first_turn = true

# Sinais para notificar outras partes do jogo sobre mudanças nesses atributos
signal player_hp_changed(new_hp: int)
signal player_mana_changed(new_mana: int)
signal opponent_hp_changed(new_hp: int)
signal opponent_mana_changed(new_mana: int)

signal player_dead
signal opponent_dead

func _ready():
	initialize_game_attributes()

func initialize_game_attributes():
	initial_cards()

func initial_cards():
	for i in range(4):
		await get_tree().create_timer(0.25).timeout
		card_manager.draw_card_player()
		await get_tree().create_timer(0.25).timeout
		card_manager.draw_card_opponent()
		
func next_round():
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

#func change_turn():
	#
	#if current_turn_player == players.PLAYER:
		#current_turn_player = players.OPPONENT
	#else:
		#current_turn_player = players.PLAYER
	#emit_signal("turn_changed", current_turn_player)



func is_player_turn():
	return current_turn_player == players.PLAYER
	
func is_opponent_turn():
	return current_turn_player == players.OPPONENT
	
	
# --- Setter Functions for HP ---
func set_player_hp(new_value: int) -> void:
	player_hp = new_value
	if player_hp <= 0:
		emit_signal("player_dead")
		return
	emit_signal("player_hp_changed", player_hp)

func set_opponent_hp(new_value: int) -> void:
	opponent_hp = new_value
	if opponent_hp <= 0:
		emit_signal("opponent_dead")
		return
	emit_signal("opponent_hp_changed", opponent_hp)

# --- Setter Functions for Mana ---
func set_player_mana(new_value: int) -> void:
	player_mana = new_value
	emit_signal("player_mana_changed", player_mana)

func set_opponent_mana(new_value: int) -> void:
	opponent_mana = new_value
	emit_signal("opponent_mana_changed", opponent_mana)

func player_take_damage(dmg: int):
	set_player_hp(player_hp - dmg)
	
func opponent_take_damage(dmg: int):
	set_opponent_hp(opponent_hp - dmg)

func opponent_buy_card(card: Card, check: bool=false):
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
	
	
func player_buy_card(card: Card, check: bool=false):
	if not is_player_turn() or player_mana < card._cost:
		return false
	if check:
		return true
	set_player_mana(player_mana - card._cost)
	player.remove_card_from_hand(card)
	player.add_card_to_bench(card)
	
	number_of_plays_last_turn_player +=1
	
func opponent_play_card(card: Card, check: bool=false):
	if (card.state != Card.fields.Bench
		or not is_opponent_turn()
		or has_attack_token == players.OPPONENT):
			
		return false
	if check:
		return true
	opponent.remove_card_from_bench(card)
	opponent.add_card_to_field(card)
	card.change_state(Card.states.InField)
	card.change_field(Card.fields.Combat)
	
	number_of_plays_last_turn_opponent += 1
	
	opponent_ai_manager.next_play()
	
func player_play_card(card: Card, check: bool=false):
	if not is_player_turn():
		return false
	if check:
		return true
	player.remove_card_from_bench(card)
	player.add_card_to_field(card)
	card.change_state(Card.states.InField)
	card.change_field(Card.fields.Combat)
	
	number_of_plays_last_turn_player += 1
	
func increase_number_of_plays_last_turn_player():
	pass
	
func increase_number_of_plays_last_turn_opponent():
	pass
	
func end_turn():
	print(number_of_plays_last_turn_opponent, number_of_plays_last_turn_player, is_first_turn)
	if (
		number_of_plays_last_turn_opponent == 0 and
		number_of_plays_last_turn_player == 0 and
		not is_first_turn
	):
		print("next_round")
		number_of_plays_last_turn_opponent = 0
		number_of_plays_last_turn_player = 0
		is_first_turn = true
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


func _on_action_button_pressed() -> void:
	match current_turn_player:
		players.PLAYER:
			end_turn()
