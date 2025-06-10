extends CanvasLayer

@onready var action_button: Button = $ActionButton

@onready var player_ui: Control = $PlayerUI
@onready var opponent_ui: Control = $OpponentUI

@onready var player_hp: Label = $PlayerUI/PlayerHP
@onready var player_mana: Label = $PlayerUI/PlayerMana

@onready var opponent_hp: Label = $OpponentUI/OpponentHP
@onready var opponent_mana: Label = $OpponentUI/OpponentMana

@onready var round_number: Label = $RoundUI/RoundNumber
@onready var attack_token: Label = $RoundUI/AttackToken
	


func _on_game_state_manager_opponent_hp_changed(new_hp: int) -> void:
	opponent_hp.text = str("HP: ", new_hp)

func _on_game_state_manager_opponent_mana_changed(new_mana: int) -> void:
	opponent_mana.text = str("Mana: ", new_mana)

func _on_game_state_manager_player_hp_changed(new_hp: int) -> void:
	player_hp.text = str("HP: ", new_hp)
	
func _on_game_state_manager_player_mana_changed(new_mana: int) -> void:
	player_mana.text = str("Mana: ", new_mana)


func _on_game_state_manager_turn_changed(turn_player: GameStateManager.players) -> void:
	match turn_player:
		GameStateManager.players.PLAYER:
			action_button.text = "Encerrar Turno"
		GameStateManager.players.OPPONENT:
			action_button.text = "Turno do Oponente"

func _on_game_state_manager_round_changed(number: int) -> void:
	round_number.text = str("Round: ", number)


func _on_game_state_manager_attack_token_changed(attack_token_player: GameStateManager.players) -> void:
	attack_token.text = str("Attack Token:", (
		"Player"
		if attack_token_player == GameStateManager.players.PLAYER
		else "Opponent"
		))
