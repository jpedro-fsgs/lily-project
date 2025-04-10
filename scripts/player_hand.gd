extends CanvasLayer

@onready var card_container: HBoxContainer = $CardContainer
const CARD = preload("res://scenes/card.tscn")
var cards = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func add_card(new_card) -> void:
	card_container.add_child(new_card)
	#cards.append(new_card)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
