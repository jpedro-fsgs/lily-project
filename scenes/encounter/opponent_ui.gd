extends Control

@onready var opponent_hp: Label = $OpponentHP
@onready var opponent_mana: Label = $OpponentMana


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_hp(hp: int):
	opponent_hp.text = str("HP: ", hp)

func set_mana(mana: int):
	opponent_hp.text = str("Mana: ", mana)
	
