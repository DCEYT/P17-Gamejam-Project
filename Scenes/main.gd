extends Node2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
const BOSS_BATTLE_WIP = preload("res://Sounds/BOSSBATTAL MUSIC P2 WIP.mp3")
@onready var scene_transition_animation = $SceneTransitionAnimation/AnimationPlayer
@onready var SceneTransition: Node2D = $SceneTransitionAnimation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransition.visible = true
	audio_stream_player_2d.volume_db = -80
	scene_transition_animation.play("fade_out")
	musicaa()
	await get_tree().create_timer(1).timeout
	SceneTransition.visible = false
	
func musicaa():
	for i in range(800):
		if audio_stream_player_2d.volume_db <= 0:
			audio_stream_player_2d.volume_db += .1
		await get_tree().create_timer(0.001).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !audio_stream_player_2d.is_playing():
		audio_stream_player_2d.stream = BOSS_BATTLE_WIP
		audio_stream_player_2d.play()
