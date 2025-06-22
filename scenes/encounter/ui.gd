extends CanvasLayer

@onready var action_button: Button = $ActionButtonMask/ActionButton

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

func player_damage():
	var current_tween = create_tween()
	current_tween.tween_property(player_hp, "modulate", Color.RED, 0.5)
	current_tween.chain().tween_property(player_hp, "modulate", Color.WHITE, 0.5)
	await current_tween.finished

func opponent_damage():
	var current_tween = create_tween()
	current_tween.tween_property(opponent_hp, "modulate", Color.RED, 0.5)
	current_tween.chain().tween_property(opponent_hp, "modulate", Color.WHITE, 0.5)
	await current_tween.finished


func _on_game_state_manager_turn_changed(turn_player: GameStateManager.players) -> void:
	match turn_player:
		GameStateManager.players.PLAYER:
			action_button.text = "Encerrar Turno"
			action_button.disabled = false
		GameStateManager.players.OPPONENT:
			action_button.text = "Turno do Oponente"
			action_button.disabled = true

func _on_game_state_manager_round_changed(number: int) -> void:
	round_number.text = str("Round: ", number)


func _on_game_state_manager_attack_token_changed(attack_token_player: GameStateManager.players) -> void:
	attack_token.text = str("Token de Ataque: ", (
		"Player"
		if attack_token_player == GameStateManager.players.PLAYER
		else "Oponente"
		))
