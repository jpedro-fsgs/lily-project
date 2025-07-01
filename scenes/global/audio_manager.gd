extends Node
# Autoload como "AudioManager"

var music_library = [
	preload("res://assets/audio/Lily.mp3"),                       # Menu
	preload("res://assets/audio/Eu sonhei com este Jardim.mp3"),  # Gameplay 1
	preload("res://assets/audio/Retorno à Felicidade.mp3"),       # Gameplay 2
]

var _music_player: AudioStreamPlayer
var current_song_index: int = -1
var is_gameplay_mode = false

func _ready():
	_music_player = AudioStreamPlayer.new()
	add_child(_music_player)
	_music_player.bus = "Music"
	_music_player.autoplay = false
	_music_player.connect("finished", Callable(self, "_on_music_finished"))


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
