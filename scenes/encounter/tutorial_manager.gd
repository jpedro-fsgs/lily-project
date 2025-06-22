extends Node2D
class_name TutorialManager

var enable_tutorial = true
	
var tutoriais = [
	"tutorial1",
	"tutorial2",
	"tutorial3",
	"tutorial4",
	"tutorial5",
	"tutorial6",
]
var count := 0

func next_dialog(index: int):
	print_debug(index)
	if not enable_tutorial or index <= count:
		return
	if index > tutoriais.size():
		enable_tutorial = false
		return
	
	count = index
	Dialogic.start(tutoriais[index - 1])
	await Dialogic.timeline_ended
