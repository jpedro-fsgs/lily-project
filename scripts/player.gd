class_name Player
extends Node2D

@onready var cards: Node2D = $Cards

@onready var CentreCardOval = Vector2(get_viewport().size) * Vector2(0.5, 1.2)
@onready var Hor_rad = get_viewport().size.x * 0.45
@onready var Ver_rad = get_viewport().size.y * 0.4

var angle = 0
var OvalAngleVector: Vector2
@onready var CardSpread = get_viewport().size.x * 0.00014

enum hand_positions {
	TOP,
	BOTTOM
}

var hand_position = hand_positions.BOTTOM

func toggle_cards_position(new_hand_position: hand_positions) -> void:
	match new_hand_position:
	# Atualiza a posição do centro do oval e a visibilidade das cartas
		hand_positions.TOP:
			hand_position = hand_positions.TOP
			CentreCardOval = Vector2(get_viewport().size) * Vector2(0.5, -0.25)
		hand_positions.BOTTOM:
			hand_position = hand_positions.BOTTOM
			CentreCardOval = Vector2(get_viewport().size) * Vector2(0.5, 1.25)
	# Atualiza as posições das cartas
	update_hand()

# Função para definir explicitamente a posição das cartas
#func set_cards_position(on_top: bool) -> void:
	#if show_cards_on_top != on_top:
		#show_cards_on_top = on_top
		#if show_cards_on_top:
			#CentreCardOval = Vector2(get_viewport().size) * Vector2(0.5, 0.2)
		#else:
			#CentreCardOval = Vector2(get_viewport().size) * Vector2(0.5, 1.2)
		#update_hand()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_card_to_hand(new_card: Card):
	cards.add_child(new_card)
	update_hand()
	new_card.change_state(Card.states.MoveDrawnCardToHand)
	
func remove_card_from_hand(card: Card):
	cards.remove_child(card)
	update_hand()
	#new_card.change_state(Card.states.MoveDrawnCardToHand) 
	

func update_hand():
	var hand = cards.get_children()
	var card_count = hand.size()

	if card_count == 0:
		return
	
	var start_angle
	var end_angle
	
	match hand_position:
	# Calcula o ângulo inicial e final para distribuir as cartas em arco
		hand_positions.BOTTOM:
			start_angle = PI/2 + CardSpread * (card_count-1) / 2
			end_angle = PI/2 - CardSpread * (card_count-1) / 2
	
		hand_positions.TOP:
			start_angle = 3 * PI/2 - CardSpread * (card_count-1) / 2
			end_angle = 3 * PI/2 + CardSpread * (card_count-1) / 2

	# Distribuição do ângulo entre as cartas
	var angle_step = 0
	if card_count > 1:
		angle_step = (end_angle - start_angle) / (card_count - 1)

	# Atualiza posição e rotação de cada carta
	for i in range(card_count):
		var card = hand[i]
		var current_angle = start_angle + angle_step * i
		var oval_pos = Vector2(Hor_rad * cos(current_angle), -Ver_rad * sin(current_angle))
		
		card._targetpos = CentreCardOval + oval_pos - card.size/2
		
		match hand_position:
			hand_positions.BOTTOM:
				card._targetrot = (90 - rad_to_deg(current_angle)) * 0.0075
			hand_positions.TOP:
				card._targetrot = (270 - rad_to_deg(current_angle)) * 0.0075
			
		

		card.change_state(Card.states.InHand)
