extends Control

@onready var cardback: Sprite2D = $ControlBody/Cardback
@onready var card_image: Sprite2D = $ControlBody/CardImage
@onready var name_label: Label = $ControlBody/Name
@onready var effect_label: Label = $ControlBody/Effect



const PATH = "res://assets/flowers/"

var is_card_being_dragged = false

var _name: String
var _type: String
var _attack: int
var _defense: int
var _cost: int
var _effect: String

var original_position: Vector2


func set_attributes(card_attributes) -> void:
	_name = card_attributes["name"]
	_type = card_attributes["type"]
	#_attack = card_attributes["attack"]
	#_defense = card_attributes["defense"]
	_cost = card_attributes["cost"]
	_effect = card_attributes["effect"]

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = position
	cardback.visible = false
	var num = int(randi_range(1,34))
	card_image.texture = load(str(PATH, 'flor', num, '.png'))
	name_label.text = _name
	effect_label.text = _effect
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_card_being_dragged:
		position = get_global_mouse_position()
	

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", original_position - Vector2(0, 20), 0.2)


func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", original_position, 0.2)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			scale = Vector2(1.5, 1.5)
		elif event.is_released():
			scale = Vector2(1, 1)
