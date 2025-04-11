extends Control

@onready var cardback: Sprite2D = $CardBody/Cardback
@onready var card_image: Sprite2D = $CardBody/CardImage
@onready var name_label: Label = $CardBody/Name
@onready var effect_label: Label = $CardBody/Effect
@onready var cost_label: Label = $CardBody/CostIcon/CostLabel



const PATH = "res://assets/flowers/"

var _name: String
var _type: String
#var _attack: int
#var _defense: int
var _cost: int
var _effect: String

var _index
var _original_scale = Vector2(0.5, 0.5)
var _startpos = Vector2(0,0)
var _targetpos = Vector2(0,0)
var _startrot = deg_to_rad(0)
var _targetrot = deg_to_rad(0)

var current_tween: Tween = null

enum{
	InHand,
	InPlay,
	InMouse,
	FocusInHand,
	MoveDrawnCardToHand,
	ReOrganizeHand
}
var state = InHand

func set_attributes(card_attributes) -> void:
	_name = card_attributes["name"]
	_type = card_attributes["type"]
	#_attack = card_attributes["attack"]
	#_defense = card_attributes["defense"]
	_cost = card_attributes["cost"]
	_effect = card_attributes["effect"]
	

# Called when the node enters the scene tree for the first time.
func _ready():
	position = _startpos
	rotation = _startrot
	_index = get_index()
	cardback.visible = false
	var num = int(randi_range(1,34))
	card_image.texture = load(str(PATH, 'flor', num, '.png'))
	name_label.text = _name
	effect_label.text = _effect
	cost_label.text = str(_cost)
	
		
func animate_to_hand():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "position", _targetpos, 0.5)
	print(_targetpos)
	tween.tween_property(self, "scale", _original_scale, 0.1)
	tween.tween_property(self, "rotation", _targetrot, 0.1)

func _process(_delta: float) -> void:
	match state:
		InMouse:
			# Para o estado InMouse, precisamos atualizar a posição a cada frame
			var global_mouse_pos = get_viewport().get_mouse_position()
			var local_mouse = get_parent().get_canvas_transform().affine_inverse() * global_mouse_pos
			position = local_mouse - (size / 2)

func change_state(new_state):
	state = new_state
	
	# Cancela qualquer tween anterior
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	
	# Cria um novo tween baseado no estado
	current_tween = create_tween()
	
	match state:
		InHand:
			z_index = 1
			current_tween.set_parallel()
			current_tween.tween_property(self, "position", _targetpos, 0.2)
			current_tween.tween_property(self, "scale", _original_scale, 0.1)
			current_tween.tween_property(self, "rotation", _targetrot, 0.1)
		InPlay:
			pass
		InMouse:
			# Note que a posição atual é atualizada no _process
			z_index = 2
			current_tween.tween_property(self, "rotation", _startrot, 0.1)
		FocusInHand:
			current_tween.set_parallel()
			current_tween.tween_property(self, "position:y", _targetpos.y - 70, 0.2)
			current_tween.tween_property(self, "scale", _original_scale * 1.2, 0.2)
		MoveDrawnCardToHand:
			current_tween.set_parallel()
			current_tween.tween_property(self, "position", _targetpos, 0.5)
			current_tween.tween_property(self, "rotation", _targetrot, 0.5)
			current_tween.tween_property(self, "scale", _original_scale, 0.1)
			current_tween.chain().tween_callback(func():
				change_state(InHand)  # Supondo que InHand seja uma constante ou enum
			)
		ReOrganizeHand:
			pass
		
	
func _on_mouse_entered() -> void:
	if state != InHand:
		return
	change_state(FocusInHand)

func _on_mouse_exited() -> void:
	if state != FocusInHand:
		return
	change_state(InHand)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			change_state(InMouse)
		elif event.is_released():
			change_state(InHand)
