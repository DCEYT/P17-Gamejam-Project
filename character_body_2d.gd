extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 700
const JUMP_VELOCITY = -1100

const RUN_SPEED = 1000
const DOWN_SPEED = 800
const DASH_SPEED = 3000
var running = false
var dashing = false
var can_dash = true

func _ready():
	Global.playerBody = self

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("Move Down") and not is_on_floor():
		print(velocity.y)
		if velocity.y < 0:
			velocity.y = 0
		velocity.y += DOWN_SPEED


	if Input.is_action_just_pressed("Dash") and can_dash:
		dashing = true
		can_dash = false
		print("dash")
		$Dash_Timer.start()
		$Can_Dash_Timer.start()
	
	if Input.is_action_just_pressed("Run"):
		running = true
	
	if Input.is_action_just_released("Run"):
		running = false
		
	if Input.is_action_just_pressed("Move Left"):
		animated_sprite_2d.flip_h = false
	elif Input.is_action_just_pressed("Move Right"):
		animated_sprite_2d.flip_h = true
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Move Left", "Move Right")
	if direction:
		if dashing:
			velocity.x = direction * DASH_SPEED
		elif running:
			animated_sprite_2d.animation = "run"
			velocity.x = direction * RUN_SPEED
		else:
			animated_sprite_2d.animation = "walk"
			velocity.x = direction * SPEED
	else:
		animated_sprite_2d.animation = "idle"
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_can_dash_timer_timeout() -> void:
	can_dash = true
