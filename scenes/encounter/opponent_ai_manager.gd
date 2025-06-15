extends Node2D
class_name OpponentAIManager

@onready var game_state_manager: GameStateManager = $"../GameStateManager"
@onready var combat_resolver: CombatResolver = $"../CombatResolver"

@onready var player_field: PlayerField = $"../Players/Player/PlayerField"
@onready var player_bench: PlayerBench = $"../Players/Player/PlayerBench"

@onready var opponent_card_hand: CanvasLayer = $"../Players/Opponent/OpponentHand"
@onready var opponent_field: OpponentField = $"../Players/Opponent/OpponentField"
@onready var opponent_bench: OpponentBench = $"../Players/Opponent/OpponentBench"

@onready var player: Player = $"../Players/Player"
@onready var opponent: Opponent = $"../Players/Opponent"

@onready var http_request: HTTPRequest = $HTTPRequest


func update_available_cards():
	var available_card_slots = []
	var available_plays = []
	
	if combat_resolver.player_has_card_on_field() and randi() % 5 > 0:
		for card_slot in player_field.card_slots.get_children():
			var eq_card_slot = combat_resolver.eq_field[card_slot]
			if card_slot.card and not eq_card_slot.card:
				available_card_slots.append(eq_card_slot)
	else:
		for card_slot in opponent_field.card_slots.get_children():
			if not card_slot.card:
				available_card_slots.append(card_slot)
	
	for card in opponent_card_hand.get_children():
		if game_state_manager.opponent_buy_card(card, true):
			available_plays.append({
				"card": card,
				"card_slot": null,
				"play": Callable(game_state_manager, "opponent_buy_card")
			})
	for slot in opponent_bench.card_slots.get_children():
		var card = slot.card
		for card_slot in available_card_slots:
			if card and game_state_manager.opponent_play_card(card, true, card_slot):
				available_plays.append({
					"card": card,
					"card_slot": card_slot,
					"play": Callable(game_state_manager, "opponent_play_card")
				})
	
	available_plays.append({
			"card": null,
			"card_slot": null,
			"play": Callable(game_state_manager, "end_turn")
		})
			
	return available_plays

func get_random_play(plays: Array):
	if plays:
		var i = randi() % plays.size()
		var play = plays[i]
		return play
		
func exec_play(play):
	if play["card"]:
		if play["card_slot"]:
			play["play"].call(play["card"], false, play["card_slot"])
			return
		play["play"].call(play["card"])
		
		return
	play["play"].call()
	
func get_llm_play(available_plays, model="llama3.2"):
	var available_plays_description = []
	for play in available_plays:
		var card: Card = play["card"]
		if not card:
			available_plays_description.append("End Turn")
			continue
		var card_description = ("Carta: " + card._name + "\n" +
							   "Tipo: " + card._type + "\n" +
							   "Custo: " + str(card._cost) + "\n" +
							   "Ataque: " + str(card._attack) + "\n" +
							   "Defesa: " + str(card._defense) + "\n" +
							   "Efeito: " + card._effect)
		available_plays_description.append(card_description)
	var player_cards_description = []
	

	for play in player_field.card_slots.get_children():
		var card: Card = play.card
		if not card:
			available_plays_description.append("End Turn")
			continue
		var card_description = ("Carta: " + card._name + "\n" +
							   "Tipo: " + card._type + "\n" +
							   "Custo: " + str(card._cost) + "\n" +
							   "Ataque: " + str(card._attack) + "\n" +
							   "Defesa: " + str(card._defense) + "\n" +
							   "Efeito: " + card._effect)
		player_cards_description.append(card_description)
	
	var prompt = (
		"Você está jogando um jogo de cartas (TCG)." +
		"Seu HP está em " + str(game_state_manager.opponent_hp) + " e você tem " + str(game_state_manager.opponent_mana) +
		". Escolha sua próxima jogada entre as seguintes opções:\n" +
		str(available_plays_description) +
		"\n As cartas no campo do seu oponente são: " +
		str(player_cards_description) +
		"\nResponda **apenas** com o índice (número inteiro) da jogada desejada no array. O tamanho do array é " +
		str(available_plays.size()) + ". Sua resposta será convertida diretamente para um inteiro."
	)

	var payload = {
		"model": model,
		"prompt": prompt,
		"stream": false
	}
	var json = JSON.stringify(payload)
	var headers = ["Content-Type: application/json"]
	http_request.request("http://localhost:11434/api/generate", headers, HTTPClient.METHOD_POST, json)
	var result = await http_request.request_completed
	var response_code = result[1]
	var body = result[3]

	var play: String = JSON.parse_string(body.get_string_from_utf8())["response"]
	
	if response_code == 200 and play.is_valid_int() and int(play) < available_plays.size():
		return available_plays[int(play)]
		
	print_debug("LLM Error")
	return null


func next_play() -> void:
	var available_plays = update_available_cards()
	var play = null
	#play = await get_llm_play(available_plays)
	
	if not play:
		play = get_random_play(available_plays)
	
	await get_tree().create_timer(0.5).timeout
	exec_play(play)
