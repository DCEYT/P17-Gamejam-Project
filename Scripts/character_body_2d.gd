extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var deal_damage_zone = $DealDamageZone

const SPEED = 700
const JUMP_VELOCITY = -1100

const RUN_SPEED = 1000
const DOWN_SPEED = 800
const DASH_SPEED = 3000
var running = false
var dashing = false
var can_dash = true

var attack_type: String
var current_attack: bool

const gravity = 1100

func _ready():
	Global.playerBody = self
	current_attack = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

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
		deal_damage_zone.scale.x = 1
	elif Input.is_action_just_pressed("Move Right"):
		animated_sprite_2d.flip_h = true
		deal_damage_zone.scale.x = -1
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Move Left", "Move Right")
	if direction:
		if dashing: 
			if !current_attack:
				animated_sprite_2d.play("dash")
			velocity.x = direction * DASH_SPEED
		elif running:
			if !current_attack:
				animated_sprite_2d.play("run")
			velocity.x = direction * RUN_SPEED
		else:
			if !current_attack:
				animated_sprite_2d.play("walk")
			velocity.x = direction * SPEED
	else:
		if !current_attack:
			animated_sprite_2d.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if !current_attack:
		if Input.is_action_just_pressed("Attack") or Input.is_action_just_pressed("Attack2"):
			current_attack = true
			if Input.is_action_just_pressed("Attack") and is_on_floor():
				attack_type = "single"
			elif Input.is_action_just_pressed("Attack2") and is_on_floor():
				attack_type = "heavy"
			else:
				attack_type = "air"
			handle_attack_animation(attack_type)
				
	move_and_slide()


func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_can_dash_timer_timeout() -> void:
	can_dash = true
	

func handle_attack_animation(attack_type):
	if current_attack:
		var animation = str(attack_type, "_attack")
		animated_sprite_2d.play(animation)
		print(animation)
		toggle_damage_collisions(attack_type)

func toggle_damage_collisions(attack_type):
	var damage_zone_collision = deal_damage_zone.get_node("CollisionShape2D")
	var wait_time: float
	if attack_type == "air":
		wait_time = .6
	elif attack_type == "single":
		wait_time = .6
	elif attack_type == "heavy":
		wait_time = .8
	damage_zone_collision.disabled = false
	await get_tree().create_timer(wait_time).timeout
	damage_zone_collision.disabled = true


func _on_animated_sprite_2d_animation_finished():
	current_attack = false
