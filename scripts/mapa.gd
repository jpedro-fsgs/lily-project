extends Node2D

@onready var rose_portal: TextureButton = $MapaJardim2/RosePortal

var amplitude : float = 10.0 # A altura do pulo
var velocidade : float = 5.0 # A velocidade do movimento
var tempo : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tempo += delta * velocidade
	var movimento = sin(tempo) * amplitude
	rose_portal.position.y = movimento


func _on_rose_portal_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_manager.tscn")
