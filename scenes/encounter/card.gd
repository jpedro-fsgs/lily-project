extends Control
class_name Card

@onready var card_body: Node2D = $CardBody

@onready var cardback: Sprite2D = $CardBody/Cardback
@onready var card_image: Sprite2D = $CardBody/CardImage
@onready var name_label: Label = $CardBody/Name
@onready var effect_label: Label = $CardBody/Effect
@onready var cost_label: Label = $CardBody/CostLabel
@onready var attack_label: Label = $CardBody/AttackLabel
@onready var defense_label: Label = $CardBody/DefenseLabel
@onready var drop_point_detector: Area2D = $DropPointDetector

var belongs_to: GameStateManager.players

var card_slot: CardSlot = null

signal card_selected(card, mouse_position_on_card)
signal card_released(card)

signal card_hovered(card)
signal card_unhovered(card)

signal dead_card(card)

const PATH = "res://assets/"

var _name: String
var _type: String
var _attack: int
var _defense: int
var _cost: int
var _effect: String
var _image_path: String
var _is_face_down: bool


var _original_scale = Vector2(0.5, 0.5)
var _startpos = Vector2(0,0)
var _targetpos = Vector2(0,0)
var _startrot = deg_to_rad(0)
var _targetrot = deg_to_rad(0)

var current_tween: Tween = null

enum states {
	InHand,
	InBench,
	InField,
	InPlay,
	InMouse,
	FocusInHand,
	MoveDrawnCardToHand,
	ReOrganizeHand,
	Dead
}

enum fields {
	Hand,
	Bench,
	Combat
}

var state: states
var field: fields

var bottom_card = true
var mouse_position_on_card

func set_attributes(card_attributes, is_face_down=false) -> void:
	_name = card_attributes["carta"]
	_type = card_attributes["tipo"]
	_attack = card_attributes["duração_ou_atk"] if card_attributes["duração_ou_atk"] else 0
	_defense = card_attributes["área_ou_def"] if card_attributes["área_ou_def"] else 0
	_cost = card_attributes["mana"]
	_effect = card_attributes["efeito"]
	_image_path = card_attributes["image_url"]
	_is_face_down = is_face_down
	field = fields.Hand
	_update_card()
	

# Called when the node enters the scene tree for the first time.
func _update_card():
	await ready
	position = _startpos
	rotation = _startrot
	card_image.texture = load(str(PATH, _image_path))
	name_label.text = _name
	effect_label.text = _effect
	cost_label.text = str(int(_cost))
	attack_label.text = str(int(_attack) if _attack else 0)
	defense_label.text = str(int(_defense) if _defense else 0)
	if _is_face_down:
		cardback.visible = true
		cardback.flip_v = true

#func _ready() -> void:
	#pass


#func _process(_delta: float) -> void:
	#if state == states.InMouse:
		#global_position = get_global_mouse_position() - mouse_position_on_card * scale
		
func change_field(new_field: fields):
	field = new_field

func change_state(new_state: states):
	state = new_state
	# Cancela qualquer tween anterior
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	
	# Cria um novo tween baseado no estado
	current_tween = create_tween()
	
	match state:
		states.InHand:
			z_index = 1
			current_tween.set_parallel()
			current_tween.tween_property(self, "position", _targetpos, 0.3)
			current_tween.tween_property(self, "scale", _original_scale, 0.1)
			current_tween.tween_property(self, "rotation", _targetrot, 0.2)
		states.InBench:
			current_tween.set_parallel()
			current_tween.tween_property(self, "position", _targetpos, 0.2)
			current_tween.tween_property(self, "rotation", _startrot, 0.2)
			current_tween.tween_property(self, "scale", _original_scale, 0.2)
		states.InField:
			current_tween.set_parallel()
			current_tween.tween_property(self, "position", _targetpos, 0.2)
			current_tween.tween_property(self, "rotation", _startrot, 0.2)
			current_tween.tween_property(self, "scale", _original_scale, 0.2)
		states.InPlay:
			pass
		states.InMouse:
			# Note que a posição atual é atualizada no _process
			z_index = 2
			current_tween.set_parallel()
			current_tween.tween_property(self, "rotation", _startrot, 0.1)
			current_tween.tween_property(self, "scale", _original_scale * 1.1, 0.1)
		states.FocusInHand:
			current_tween.set_parallel()
			current_tween.tween_property(self, "position", _targetpos, 0.3)
			current_tween.tween_property(self, "rotation", _targetrot, 0.2)
			current_tween.tween_property(self, "scale", _original_scale * 1.2, 0.2)
			z_index = 2
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
		states.Dead:
			current_tween.tween_method(
			  func(value): card_image.material.set_shader_parameter("amount", value),  
			  0.0,  # Start value
			  20.0,  # End value
			  2
			)
			current_tween.chain().tween_callback(func():
				queue_free()
			)

		
	
func _on_mouse_entered() -> void:
	emit_signal("card_hovered", self)


func _on_mouse_exited() -> void:
	emit_signal("card_unhovered", self)

	
func hide_card():
	cardback.visible = true
	
func show_card():
	cardback.visible = false
	
func receive_damage(dmg: int):
	_defense -= dmg
	if _defense <= 0:
		_defense = 0
		emit_signal("dead_card", self)
		change_state(states.Dead)
		
	defense_label.text = str(int(_defense))

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			mouse_position_on_card = event.position
			emit_signal("card_selected", self, mouse_position_on_card)
		elif event.is_released():
			emit_signal("card_released", self)
