extends Control

@onready var player_hp: Label = $PlayerHP
@onready var player_mana: Label = $PlayerMana

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_hp(hp: int):
	if is_node_ready():
		player_hp.text = str("HP: ", hp)

func set_mana(mana: int):
	if is_node_ready():
		player_mana.text = str("Mana: ", mana)
	


func _on_game_state_manager_player_hp_changed(new_hp: int) -> void:
	set_hp(new_hp)


func _on_game_state_manager_player_mana_changed(new_mana: int) -> void:
	set_mana(new_mana)
