extends Node2D

@onready var scene_transition_animation = $SceneTransitionAnimation/AnimationPlayer

func _ready():
	scene_transition_animation.play("fade_out")

func _on_video_stream_player_finished() -> void:
	scene_transition_animation.play("fade_in")
	await get_tree().create_timer(.5).timeout
	get_tree().change_scene_to_file("res://Scenes/martha_room.tscn")
