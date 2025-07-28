extends CheckButton
@onready var clicks: AudioStreamPlayer2D = $"../../ClickSounds"

func _on_toggled(toggled_on: bool) -> void:
	clicks.play()
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
