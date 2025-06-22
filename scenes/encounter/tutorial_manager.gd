extends Node2D
class_name TutorialManager
	
var tutoriais = [
	"tutorial1",
	"tutorial2",
	"tutorial3",
	"tutorial4",
	"tutorial5",
	"tutorial6",
]
var count := 0

func _ready():
	Dialogic.VAR.enable_tutorial = true

func next_dialog(index: int):
	if not Dialogic.VAR.enable_tutorial or index <= count:
		return
	if index > tutoriais.size():
		Dialogic.VAR.enable_tutorial = false
		return
	
	count = index
	Dialogic.start(tutoriais[index - 1])
	await Dialogic.timeline_ended
