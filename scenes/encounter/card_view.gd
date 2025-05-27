extends Control

const PATH = "res://assets/"

@onready var card_image: Sprite2D = $CardBody/CardMask/CardImage
@onready var name_label: Label = $CardBody/Name
@onready var effect_label: Label = $CardBody/Effect
@onready var cost_label: Label = $CardBody/CostLabel
@onready var attack_label: Label = $CardBody/AttackLabel
@onready var defense_label: Label = $CardBody/DefenseLabel



func _ready():
	visible=false
	
func _process(delta: float):
	pass

func _on_card_manager_view_card(card):
	if card:
		visible = true
		card_image.texture = load(str(PATH, card._image_path))
		name_label.text = card._name
		effect_label.text = card._effect
		cost_label.text = str(int(card._cost))
		attack_label.text = str(int(card._attack) if card._attack else 0)
		defense_label.text = str(int(card._defense) if card._defense else 0)
	else:
		visible = false
