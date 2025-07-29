extends Node2D
@onready var interaction_area = $InteractionArea
@onready var speech_sound = preload("res://Sounds/a salma (mp3cut.net).mp3")
@onready var scene_transition_animation = $"../SceneTransitionAnimation/AnimationPlayer"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var lines: Array[String]

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	animated_sprite_2d.play("idle")
	if !Global.talkedMartha:
		lines = [
			"Why are you looking at me?",
			"Did you do something?",
			"Cause Big Boss is calling you.",
			"If anything happens…",
			"After all...",
			"Remember…",
			"I forgot what to say"
		]
	elif Global.talkedMartha:
		lines = [
			"We already talked..."
		]
	
func _on_interact():
	DialogManager.start_dialog(global_position, lines, speech_sound)
	await DialogManager.dialog_finished
	if !Global.talkedMartha:
		scene_transition_animation.play("fade_in")
		await get_tree().create_timer(.5).timeout
		Global.talkedMartha = true
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
	elif Global.talkedMartha:
		pass
