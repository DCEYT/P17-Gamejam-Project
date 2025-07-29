extends Node2D
const DEFAULT_GAMEJAM_MUSIC = preload("res://Sounds/DEFAULT GAMEJAM MUSIC.mp3")
@onready var music: AudioStreamPlayer2D = $Music
@onready var scene_transition_animation = $SceneTransitionAnimation/AnimationPlayer
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var static_body_2d_2: StaticBody2D = $StaticBody2D2


func _ready() -> void:
	music.volume_db = -80
	scene_transition_animation.play("fade_out")
	musicaa()
	if Global.talkedJacque:
		static_body_2d.queue_free()
	if Global.talkedMartha:
		static_body_2d_2.queue_free()
	
func musicaa():
	for i in range(800):
		if music.volume_db <= 0:
			music.volume_db += .1
		await get_tree().create_timer(0.001).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if !music.is_playing():
		music.stream = DEFAULT_GAMEJAM_MUSIC
		music.play()
	
