extends Container

@onready var cardback: Sprite2D = $Content/Cardback
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _name: String
var _type: String
var _attack: int
var _defense: int
var _cost: int
var _effect: String

func set_attributes(card_name: String, type: String, attack: int, defense: int, cost: int, effect: String) -> void:
	_name = card_name
	_type = type
	_attack = attack
	_defense = defense
	_cost = cost
	_effect = effect

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Tamanho do Card:", size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#func _on_gui_input(event: InputEvent) -> void:
	#print(event)

func _on_mouse_entered() -> void:
	print("_on_mouse_entered")
	animation_player.play("Select")


func _on_mouse_exited() -> void:
	print("_on_mouse_exited")
	animation_player.play("RESET")


func _on_gui_input(event: InputEvent) -> void:
	pass
