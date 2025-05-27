extends Node2D

@onready var card_manager: CardManager = $"../CardManager"

enum players {
	PLAYER,
	OPPONENT
}

# --- Atributos do Jogador Humano ---
var player_current_hp: int = 30  # HP atual do Nexus do jogador
var player_max_hp: int = 30      # HP máximo do Nexus do jogador
var player_current_mana: int = 0  # Mana de ação disponível neste turno

# --- Atributos do Oponente (IA) ---
var opponent_current_hp: int = 30
var opponent_max_hp: int = 30
var opponent_current_mana: int = 0

# Outras variáveis de estado importantes gerenciadas aqui:
var current_turn_player: players = players.PLAYER # Quem tem o turno ("Player" ou "Opponent")
var current_round: int = 1                 # Rodada atual do jogo
var has_attack_token: players = players.PLAYER   # Quem tem a permissão para iniciar um ataque

# Sinais para notificar outras partes do jogo sobre mudanças nesses atributos
signal player_hp_changed(new_hp)
signal player_mana_changed(current_mana)
signal opponent_hp_changed(new_hp)
signal opponent_mana_changed(current_mana)
# ... outros sinais ...

func _ready():
	initialize_game_attributes()

func initialize_game_attributes():
	player_current_hp = player_max_hp
	opponent_current_hp = opponent_max_hp
	
	player_current_mana = 1
	opponent_current_mana = 0
	# Emitir sinais iniciais para a UI
	emit_signal("player_hp_changed", player_current_hp)
	emit_signal("opponent_hp_changed", opponent_current_hp)
	emit_signal("player_mana_changed", player_current_mana)
	emit_signal("opponent_mana_changed", opponent_current_mana)

func initial_cards():
	for i in range(4):
		card_manager.draw_card_player()
		card_manager.draw_card_opponent()
		await get_tree().create_timer(0.25).timeout
		
