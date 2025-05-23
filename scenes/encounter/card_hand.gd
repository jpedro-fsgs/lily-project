extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

@onready var CentreCardOval = Vector2(get_viewport().size) * Vector2(0.5, 1.2)
@onready var Hor_rad = get_viewport().size.x * 0.5

@onready var Focus_Ver_rad = get_viewport().size.y * 0.4
@onready var Unfocus_Ver_rad = get_viewport().size.y * 0.25

var on_focus = true



var angle = 0
var OvalAngleVector: Vector2
@onready var CardSpread = 0.13

enum {
	TOP,
	BOTTOM
}

var hand_position = BOTTOM

func set_cards_position(new_hand_position) -> void:
	match new_hand_position:
	# Atualiza a posição do centro do oval e a visibilidade das cartas
		TOP:
			hand_position = TOP
			CentreCardOval = Vector2(get_viewport().size) * Vector2(0.5, -0.275)
		BOTTOM:
			hand_position = BOTTOM
			CentreCardOval = Vector2(get_viewport().size) * Vector2(0.5, 1.275)
	
	
func update_hand():
	var hand = get_children()
	var card_count = hand.size()

	if card_count == 0:
		return
	
	var start_angle
	var end_angle
	
	match hand_position:
	# Calcula o ângulo inicial e final para distribuir as cartas em arco
		BOTTOM:
			start_angle = PI/2 + CardSpread * (card_count-1) / 2
			end_angle = PI/2 - CardSpread * (card_count-1) / 2
	
		TOP:
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
		var oval_pos = Vector2(Hor_rad * cos(current_angle), -(Focus_Ver_rad if on_focus else Unfocus_Ver_rad
		) * sin(current_angle))
		
		card._targetpos = CentreCardOval + oval_pos - card.size/2
		
		match hand_position:
			BOTTOM:
				card._targetrot = (90 - rad_to_deg(current_angle)) * 0.0075
			TOP:
				card._targetrot = (270 - rad_to_deg(current_angle)) * 0.0075
			
		

		card.change_state(Card.states.InHand)
