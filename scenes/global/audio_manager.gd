extends Node
# Autoload como "AudioManager"

var music_library = [
	preload("res://assets/audio/soundtrack/Lily.mp3"),                       # Menu
	preload("res://assets/audio/soundtrack/Eu sonhei com este Jardim.mp3"),  # Gameplay 1
	preload("res://assets/audio/soundtrack/Retorno à Felicidade.mp3"),       # Gameplay 2
]

var ui_sounds = {
	"hover_in_hand": preload("res://assets/audio/effects/Minimalist6.ogg"),
	"select_card": preload("res://assets/audio/effects/Minimalist5.ogg"),
	"release_card": preload("res://assets/audio/effects/Minimalist4.ogg"),
	"card_attack": preload("res://assets/audio/effects/07_human_atk_sword_1.wav"),
	"card_damage": preload("res://assets/audio/effects/11_human_damage_2.wav"),
	"player_damage": preload("res://assets/audio/effects/15_human_dash_1.wav"),
	"card_death": preload("res://assets/audio/effects/15_human_dash_1.wav"),
	"block_sound": preload("res://assets/audio/effects/Modern15.ogg"),
}

var _music_player: AudioStreamPlayer
var current_song_index: int = -1
var is_gameplay_mode = false

var _ui_sound: AudioStreamPlayer
var _card_sound: AudioStreamPlayer

func _ready():
	_music_player = AudioStreamPlayer.new()
	_ui_sound = AudioStreamPlayer.new()
	_card_sound =  AudioStreamPlayer.new()
	
	add_child(_music_player)
	add_child(_ui_sound)
	add_child(_card_sound)
	
	_music_player.bus = "Music"
	_music_player.autoplay = false
	_music_player.connect("finished", Callable(self, "_on_music_finished"))
	
	_ui_sound.bus = "Effects"
	_card_sound.bus = "Effects"

func play_hover_in_hand():
	_ui_sound.stream = ui_sounds["hover_in_hand"]
	_ui_sound.play()
	
func play_select_card():
	_ui_sound.stream = ui_sounds["select_card"]
	_ui_sound.play()
	
func play_release_card():
	_ui_sound.stream = ui_sounds["release_card"]
	_ui_sound.play()
	
func play_card_attack():
	_card_sound.stream = ui_sounds["card_attack"]
	_card_sound.play()
	
func play_card_damage():
	_card_sound.stream = ui_sounds["card_damage"]
	_card_sound.play()
	
func play_player_damage():
	_card_sound.stream = ui_sounds["player_damage"]
	_card_sound.play()
	
func play_card_death():
	_card_sound.stream = ui_sounds["card_death"]
	_card_sound.play()
	
func play_block_sound():
	_card_sound.stream = ui_sounds["block_sound"]
	_card_sound.play()

# Música de menu em loop contínuo
func play_menu_music():
	is_gameplay_mode = false
	_music_player.stop()
	_music_player.stream = music_library[0]
	_music_player.stream_paused = false
	_music_player.play()

# Escolhe e toca uma das músicas de gameplay (índice 1 ou 2)
func play_gameplay_music():
	if is_gameplay_mode:
		return
	is_gameplay_mode = true
	_music_player.stop()
	current_song_index = randi() % 2 + 1  # 1 ou 2
	_music_player.stream = music_library[current_song_index]
	_music_player.stream_paused = false
	_music_player.play()

# Alterna entre as músicas de gameplay
func _on_music_finished():
	if is_gameplay_mode:
		var next_index =  2 if (current_song_index == 1) else 1
		current_song_index = next_index
		_music_player.stream = music_library[current_song_index]

	_music_player.play()

# Pausar
func pause_music():
	if _music_player.playing:
		_music_player.stream_paused = true

# Retomar
func resume_music():
	if _music_player.stream_paused:
		_music_player.stream_paused = false

# Parar
func stop_music():
	if _music_player.playing or _music_player.stream_paused:
		_music_player.stop()

# Checar se está ativa
func is_music_active() -> bool:
	return _music_player.playing or _music_player.stream_paused
