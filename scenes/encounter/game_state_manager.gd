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
var player_mana: int = 0  # Mana de ação disponível neste turno

# --- Atributos do Oponente (IA) ---
var opponent_hp: int = 30
var opponent_max_hp: int = 30
var opponent_mana: int = 0

# Outras variáveis de estado importantes gerenciadas aqui:
signal turn_changed(turn_player: players)
signal opponent_turn

var current_turn_player: players = players.PLAYER # Quem tem o turno ("Player" ou "Opponent")
var current_round: int = 1                 # Rodada atual do jogo
var has_attack_token: players = players.PLAYER   # Quem tem a permissão para iniciar um ataque

# Sinais para notificar outras partes do jogo sobre mudanças nesses atributos
signal player_hp_changed(new_hp: int)
signal player_mana_changed(new_mana: int)
signal opponent_hp_changed(new_hp: int)
signal opponent_mana_changed(new_mana: int)

func _ready():
	initialize_game_attributes()

func initialize_game_attributes():
	set_player_hp(player_max_hp)
	set_opponent_hp(opponent_max_hp)
	set_player_mana(30)
	set_opponent_mana(15)
	initial_cards()

func initial_cards():
	await get_tree().create_timer(0.25).timeout
	for i in range(4):
		card_manager.draw_card_player()
		await get_tree().create_timer(0.25).timeout
		card_manager.draw_card_opponent()
		await get_tree().create_timer(0.25).timeout
		
func change_turn():
	if current_turn_player == players.PLAYER:
		current_turn_player = players.OPPONENT
		emit_signal("opponent_turn")
	else:
		current_turn_player = players.PLAYER


func is_player_turn():
	return current_turn_player == players.PLAYER
	
func is_opponent_turn():
	return current_turn_player == players.OPPONENT
	
	
# --- Setter Functions for HP ---
func set_player_hp(new_value: int) -> void:
	player_hp = new_value
	emit_signal("player_hp_changed", player_hp)

func set_opponent_hp(new_value: int) -> void:
	opponent_hp = new_value
	emit_signal("opponent_hp_changed", opponent_hp)

# --- Setter Functions for Mana ---
func set_player_mana(new_value: int) -> void:
	player_mana = new_value
	emit_signal("player_mana_changed", player_mana)

func set_opponent_mana(new_value: int) -> void:
	opponent_mana = new_value
	emit_signal("opponent_mana_changed", opponent_mana)
		

func opponent_buy_card(card: Card):
	if not is_opponent_turn():
		return
	if opponent_mana < card._cost:
		return
	set_opponent_mana(opponent_mana - card._cost)
	opponent.remove_card_from_hand(card)
	opponent.add_card_to_bench(card)
	card.change_state(Card.states.InBench)
	change_turn()
	
	
func player_buy_card(card: Card):
	if not is_player_turn():
		return
	if player_mana < card._cost:
		print("mana insuficiente")
		return
	set_player_mana(player_mana - card._cost)
	player.remove_card_from_hand(card)
	player.add_card_to_bench(card)
	
	opponent_ai_manager.update_available_cards()
	change_turn()
	
func opponent_play_card(card: Card):
	if not is_opponent_turn():
		return
	opponent.remove_card_from_bench(card)
	opponent.add_card_to_field(card)
	card.change_state(Card.states.InField)
	card.change_field(Card.fields.Combat)
	change_turn()
	
func player_play_card(card: Card):
	if not is_player_turn():
		return
	player.remove_card_from_bench(card)
	player.add_card_to_field(card)
	card.change_state(Card.states.InField)
	card.change_field(Card.fields.Combat)
	change_turn()
	
