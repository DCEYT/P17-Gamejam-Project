extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer
@onready var audio_player = $AudioStreamPlayer2D

const MAX_WIDTH = 10000000000000

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2


signal finished_displaying()

func _ready():
	scale = Vector2.ZERO

func display_text(text_to_display: String, speech_sfx: AudioStream):
	text = text_to_display
	label.text = text_to_display
	audio_player.stream = speech_sfx
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
		
	global_position.x -= size.x / 2
	global_position.y -= size.y + 120
	
	label.text = ""
	
	pivot_offset = Vector2(size.x / 2, size.y)
	
	var tween = get_tree().create_tween()
	tween.tween_property(
		self, "scale", Vector2(.05, .05), 0.05
	).set_trans(
		Tween.TRANS_BACK
	)
	
	_display_letter()
	
func _display_letter():
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
		
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
			
			var new_audio_player = audio_player.duplicate()
			new_audio_player.pitch_scale += randf_range(-0.1, 0.1)
			if text[letter_index] in ["a", "e", "i", "o", "u"]:
				new_audio_player.pitch_scale += 0.2
			get_tree().root.add_child(new_audio_player)
			new_audio_player.play()
			await new_audio_player.finished
			new_audio_player.queue_free()

func _on_letter_display_timer_timeout() -> void:
	_display_letter()
