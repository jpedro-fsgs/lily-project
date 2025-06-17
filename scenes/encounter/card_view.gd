extends Control

const PATH = "res://assets/"

@onready var card_image: Sprite2D = $CardBody2/CardImage
@onready var name_label: Label = $CardBody2/Name
@onready var effect_label: Label = $CardBody2/Effect
@onready var cost_label: Label = $CardBody2/CostLabel
@onready var attack_label: Label = $CardBody2/AttackLabel
@onready var defense_label: Label = $CardBody2/DefenseLabel

const player_pos = Vector2(753.0, 144.0)
const opponent_pos = Vector2(753.0, 532.0)


func _ready():
	visible=false
	
func _process(_delta: float):
	pass

func _on_card_manager_view_card(card: Card):
	if card:
		if card.belongs_to == GameStateManager.players.PLAYER:
			position = player_pos
		else:
			position = opponent_pos
		visible = true
		card_image.texture = load(str(PATH, card._image_path))
		name_label.text = card._name
		effect_label.text = card._effect
		cost_label.text = str(int(card._cost))
		attack_label.text = str(int(card._attack) if card._attack else 0)
		defense_label.text = str(int(card._defense) if card._defense else 0)
	else:
		visible = false
