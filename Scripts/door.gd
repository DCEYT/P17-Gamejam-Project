extends Node2D
@onready var interaction_area = $InteractionArea
@onready var speech_sound = preload("res://Sounds/door-slam-sound-effect-sfx_SFjlMrsG.mp3")
@onready var scene_transition_animation = $"../SceneTransitionAnimation/AnimationPlayer"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var lines: Array[String]

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	animated_sprite_2d.play("idle")
	if Global.point == 0:
		lines = [
			"(You are too scared to enter)",
			"(Restart and actually win this time lol)"
		]
	elif Global.point == 1:
		lines = [
			"(Are you sure you want to go in?)",
			"(Interact again to enter Big Boss's Room)"
		]
	elif Global.point == 2:
		lines = [
			"(With fear, adrenaline, and horror",
			"running through your veins...",
			"hestiantly, you enter the premises)"
		]
	
func _on_interact():
	DialogManager.start_dialog(global_position, lines, speech_sound)
	await DialogManager.dialog_finished
	if Global.point == 0:
		pass
	if Global.point == 1:
		Global.point += 1
	elif Global.point == 2:
		scene_transition_animation.play("fade_in")
		await get_tree().create_timer(.5).timeout
		Global.talkedDoor = true
		get_tree().change_scene_to_file("res://Scenes/big_boss_cutscene.tscn")
