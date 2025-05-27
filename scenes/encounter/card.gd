class_name Card
extends Control

@onready var cardback: Sprite2D = $CardBody/Cardback
@onready var card_image: Sprite2D = $CardBody/CardMask/CardImage
@onready var name_label: Label = $CardBody/Name
@onready var effect_label: Label = $CardBody/Effect
@onready var cost_label: Label = $CardBody/CostLabel
@onready var attack_label: Label = $CardBody/AttackLabel
@onready var defense_label: Label = $CardBody/DefenseLabel
@onready var drop_point_detector: Area2D = $DropPointDetector

signal card_selected(card)
signal card_released(card)

signal card_hovered(card)
signal card_unhovered(card)

const PATH = "res://assets/"

var _name #: String
var _type #: String
var _attack #: int
var _defense #: int
var _cost #: int
var _effect #: String
var _image_path


var _original_scale = Vector2(0.5, 0.5)
var _startpos = Vector2(0,0)
var _targetpos = Vector2(0,0)
var _startrot = deg_to_rad(0)
var _targetrot = deg_to_rad(0)

var current_tween: Tween = null

enum states {
	InHand,
	InSlot,
	Selected,
	InPlay,
	InMouse,
	FocusInHand,
	MoveDrawnCardToHand,
	ReOrganizeHand
}
var state
var hover_enabled = true
var bottom_card = true

func set_attributes(card_attributes) -> void:
	_name = card_attributes["carta"]
	_type = card_attributes["tipo"]
	_attack = card_attributes["duração_ou_atk"]
	_defense = card_attributes["área_ou_def"]
	_cost = card_attributes["mana"]
	_effect = card_attributes["efeito"]
	_image_path = card_attributes["image_url"]
	

# Called when the node enters the scene tree for the first time.
func _ready():
	position = _startpos
	rotation = _startrot
	cardback.visible = false
	card_image.texture = load(str(PATH, _image_path))
	name_label.text = _name
	effect_label.text = _effect
	cost_label.text = str(int(_cost))
	attack_label.text = str(int(_attack) if _attack else 0)
	defense_label.text = str(int(_defense) if _defense else 0)

func _process(_delta: float) -> void:
	if state == states.Selected:
		global_position = get_global_mouse_position() - size * 0.25

func change_state(new_state):
	state = new_state
	# Cancela qualquer tween anterior
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	
	if state == states.Selected:
		return
	# Cria um novo tween baseado no estado
	current_tween = create_tween()
	
	match state:
		states.InHand:
			z_index = 1
			current_tween.set_parallel()
			current_tween.tween_property(self, "position", _targetpos, 0.3)
			current_tween.tween_property(self, "scale", _original_scale, 0.1)
			current_tween.tween_property(self, "rotation", _targetrot, 0.2)
		states.InSlot:
			current_tween.set_parallel()
			#current_tween.tween_property(self, "position", _targetpos, 0.2)
			current_tween.tween_property(self, "rotation", _startrot, 0.2)
			#current_tween.tween_property(self, "scale", _original_scale, 0.2)
		states.InPlay:
			pass
		states.InMouse:
			# Note que a posição atual é atualizada no _process
			z_index = 2
			current_tween.set_parallel()
			current_tween.tween_property(self, "rotation", _startrot, 0.1)
			current_tween.tween_property(self, "scale", _original_scale * 1.2, 0.2)
		states.FocusInHand:
			current_tween.set_parallel()
			current_tween.tween_property(self, "position:y", _targetpos.y - (70 if bottom_card else - 70), 0.2)
			current_tween.tween_property(self, "scale", _original_scale * 1.2, 0.2)
		states.MoveDrawnCardToHand:
			z_index = 2
			current_tween.set_parallel()
			current_tween.tween_property(self, "position", _targetpos, 0.5)
			current_tween.tween_property(self, "rotation", _targetrot, 0.5)
			current_tween.tween_property(self, "scale", _original_scale, 0.2)
			current_tween.chain().tween_callback(func():
				state = states.InHand
				z_index = 1
			)
		states.ReOrganizeHand:
			pass
		
	
func _on_mouse_entered() -> void:
	emit_signal("card_hovered", self)
	#if !hover_enabled or not selectable:
		#return
	#if state == states.InHand:
		#change_state(states.FocusInHand)

func _on_mouse_exited() -> void:
	emit_signal("card_unhovered", self)
	#if state == states.FocusInHand:
		#change_state(states.InHand)
		
func _set_hover_state(hover_state: bool):
	hover_enabled = hover_state
	
func hide_card():
	cardback.visible = true
	
func show_card():
	cardback.visible = false
	
func _on_turn_changed(index):
	if state == states.InSlot:
		return



func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("card_selected", self)
		elif event.is_released():
			emit_signal("card_released", self)
