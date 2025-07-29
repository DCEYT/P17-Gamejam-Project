extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var speech_sound = preload("res://Sounds/Recording_2 (mp3cut.net).mp3")
@onready var scene_transition_animation = $"../SceneTransitionAnimation/AnimationPlayer"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var lines: Array[String] 

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	animated_sprite_2d.play("idle")
	if !Global.talkedJacque:
		lines = [
			"AFTERNOON ALBE-",
			"It seems the boss is calling you.",
			"Not that I care about your lowly caste.",
			"(Jacque recently got laid off at a local grocery store)",
			"After all...",
			"The old would only serve as a nuisance...",
			"EXCEPT FOR YOU OF COURSE",
			"ESPECIALLY SINCE I, PRINCE JACQUES JR. THE 3RD-",
			"(Every other word seems to merge into each other inelligibly)"
		]
	elif Global.talkedJacque:
		lines = [
			"We have already conversed...",
		]
	
func _on_interact():
	DialogManager.start_dialog(global_position, lines, speech_sound)
	await DialogManager.dialog_finished
	if !Global.talkedJacque:
		scene_transition_animation.play("fade_in")
		await get_tree().create_timer(.5).timeout
		Global.talkedJacque = true
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
	elif Global.talkedJacque:
		pass
