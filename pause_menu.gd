extends Control
@onready var click_sounds: AudioStreamPlayer2D = $ClickSounds
@onready var main_buttons: VBoxContainer = $PanelContainer/MainButtons
@onready var options: Panel = $Options
@onready var input_button_scene = preload("res://Scenes/input_button.tscn")
@onready var action_list: VBoxContainer = $PanelContainer2/MarginContainer/VBoxContainer/ScrollContainer/ActionList
@onready var panel_container_2: PanelContainer = $PanelContainer2


var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"Move Left": "Move Left",
	"Move Down": "Move Down",
	"Move Right": "Move Right",
	"Jump": "Jump",
	"Run": "Run",
	"Dash": "Dash",
	"Attack": "Light Attack",
	"Attack2": "Heavy Attack",
	"Interact": "Interact",
	"advance_dialogue": "Advance Dialogue"
}

func _create_action_list():
	InputMap.load_from_project_settings()
	
	for item in action_list.get_children():
		item.queue_free()
		
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label = ""
			
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		
func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press Key to Bind..."
			
func _input(event):
	if is_remapping:
		if (
			event is InputEventKey or (event is InputEventMouseButton and event.pressed)
		):
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			click_sounds.play()
			
			accept_event()
			
func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")

func _ready():
	$AnimationPlayer.play("RESET")
	main_buttons.visible = true
	options.visible = false
	panel_container_2.visible = false
	_create_action_list()

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	options.visible = false
	panel_container_2.visible = false
	
func pause():
	get_tree().paused = true
	main_buttons.visible = true
	options.visible = false
	panel_container_2.visible = false
	$AnimationPlayer.play("blur")
	
func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		click_sounds.play()
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		click_sounds.play()
		resume()


func _on_resume_pressed() -> void:
	click_sounds.play()
	resume()
	


func _on_options_pressed() -> void:
	click_sounds.play()
	main_buttons.visible = false
	options.visible = true


func _on_quit_pressed() -> void:
	click_sounds.play()
	get_tree().quit()
	
func _process(delta):
	testEsc()


func _on_back_pressed() -> void:
	click_sounds.play()
	main_buttons.visible = true
	options.visible = false


func _on_keybinds_pressed() -> void:
	click_sounds.play()
	main_buttons.visible = false
	options.visible = false
	panel_container_2.visible = true
	


func _on_reset_button_pressed() -> void:
	click_sounds.play()
	_create_action_list()

func _on_back_button_pressed() -> void:
	click_sounds.play()
	main_buttons.visible = false
	options.visible = true
	panel_container_2.visible = false
