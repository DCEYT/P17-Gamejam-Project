extends Control

func _ready():
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	
func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
		print("paused")
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()
		print("resumed")


func _on_resume_pressed() -> void:
	resume()
	


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	
func _process(delta):
	testEsc()
