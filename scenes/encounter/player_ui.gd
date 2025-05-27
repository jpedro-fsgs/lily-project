extends Control

@onready var player_hp: Label = $PlayerHP
@onready var player_mana: Label = $PlayerMana

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_hp(hp: int):
	player_hp.text = str("HP: ", hp)

func set_mana(mana: int):
	player_mana.text = str("Mana: ", mana)
	
