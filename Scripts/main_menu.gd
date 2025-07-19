extends Control
@onready var music: AudioStreamPlayer2D = $Music
@onready var clicks: AudioStreamPlayer2D = $Clicks
@onready var SceneTransitionAnimation = $SceneTransitionAnimation/AnimationPlayer
@onready var scene_transition_animation: Node2D = $SceneTransitionAnimation


const DEFAULT_GAMEJAM_MUSIC = preload("res://Sounds/DEFAULT GAMEJAM MUSIC.mp3")
const CLICK___SINGLE = preload("res://Sounds/Click - Single.MP3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_transition_animation.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if !music.is_playing():
		music.stream = DEFAULT_GAMEJAM_MUSIC
		music.play()


func _on_start_pressed() -> void:
	clicks.stream = CLICK___SINGLE
	clicks.play()
	scene_transition_animation.visible = true
	SceneTransitionAnimation.play("fade_in")
	for i in range(800):
		if music.volume_db >= -80:
			music.volume_db -= .1
		await get_tree().create_timer(0.001).timeout
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/office_main.tscn")


func _on_settings_pressed() -> void:
	clicks.stream = CLICK___SINGLE
	clicks.play()
	print("settings pressed")


func _on_exit_pressed() -> void:
	clicks.stream = CLICK___SINGLE
	clicks.play()
	get_tree().quit()
