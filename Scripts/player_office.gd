extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var walk_sound: AudioStreamPlayer2D = $WalkSound
@onready var run_sound: AudioStreamPlayer2D = $RunSound

const SPEED = 500
const RUN_SPEED = 1000
const JUMP_VELOCITY = -400.0
var running = false

const gravity = 1300

func _ready():
	Global.playerBody = self
	Global.playerAlive = true
	if Global.talkedJacque and !Global.talkedMartha:
		animated_sprite_2d.flip_h = true
		position.x = 362
		position.y = 1001
	elif Global.talkedJacque and Global.talkedMartha:
		animated_sprite_2d.flip_h = true
		position.x = 1153
		position.y = 1001

func _physics_process(delta):
	Global.playerHitbox = $PlayerHitbox
	
	var direction := Input.get_axis("Move Left", "Move Right")
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("Run"):
		running = true
		
	if Input.is_action_just_released("Run"):
		running = false
			
	if Input.is_action_just_pressed("Move Left"):
		animated_sprite_2d.flip_h = false
			
	elif Input.is_action_just_pressed("Move Right"):
		animated_sprite_2d.flip_h = true

	if direction:
		if running:
			animated_sprite_2d.play("run")
			velocity.x = direction * RUN_SPEED
			if walk_sound.playing:
				walk_sound.stop()
			if !run_sound.playing:
				run_sound.play()
		else:
			animated_sprite_2d.play("walk")
			velocity.x = direction * SPEED
			if run_sound.playing:
				run_sound.stop()
			if !walk_sound.playing:
				walk_sound.play()
	else:
		animated_sprite_2d.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		walk_sound.stop()
		run_sound.stop()
		
			
	move_and_slide()
