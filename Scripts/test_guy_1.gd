extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var speech_sound = preload("res://Sounds/Recording (215).mp3")


const lines: Array[String] = [
	"Yo wassup",
	"Wait a minute...",
	"The boss is calling you btw.",
	"so you should get there",
	"right away."
]

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	DialogManager.start_dialog(global_position, lines, speech_sound)
	await DialogManager.dialog_finished
