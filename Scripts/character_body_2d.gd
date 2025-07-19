extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var deal_damage_zone = $DealDamageZone

const SPEED = 700
const JUMP_VELOCITY = -1100

const RUN_SPEED = 1400
const DOWN_SPEED = 800
const DASH_SPEED = 3000
var running = false
var dashing = false
var can_dash = true

var attack_type: String
var current_attack: bool

const gravity = 1100

var health = 100
var health_max = 100
var health_min = 0
var can_take_damage: bool
var dead: bool
var knockback_force = -200

var Enemy: CharacterBody2D

func _ready():
	Global.playerBody = self
	current_attack = false
	dead = false
	can_take_damage = true
	Global.playerAlive = true

func _physics_process(delta: float) -> void:
	Global.playerDamageZone = deal_damage_zone
	Global.playerHitbox = $PlayerHitbox
	
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if !dead:
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
				if !current_attack and can_take_damage:
					animated_sprite_2d.play("dash")
				velocity.x = direction * DASH_SPEED
			elif running:
				if !current_attack and can_take_damage:
					animated_sprite_2d.play("run")
				velocity.x = direction * RUN_SPEED
			else:
				if !current_attack and can_take_damage:
					animated_sprite_2d.play("walk")
				velocity.x = direction * SPEED
		else:
			if !current_attack and can_take_damage:
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
				
		
				set_damage(attack_type)
				handle_attack_animation(attack_type)
			check_hitbox()
	move_and_slide()

func check_hitbox():
	var hitbox_area = $PlayerHitbox.get_overlapping_areas()
	var damage: int
	if hitbox_area:
		var hitbox = hitbox_area.front()
		if hitbox.get_parent() is Enemy11:
			damage = Global.Enemy1DamageAmount
			
	if can_take_damage:
		take_damage(damage)
		
func take_damage(damage):
	if damage != 0:
		if health > 0:
			health -= damage
			print("player health: ", health)
			handle_hurt_animation()
		if health <= 0:
			health = 0
			dead = true
			Global.playerAlive = false
			handle_death_animation()
		take_damage_cooldown(1.0)

func handle_hurt_animation():
	animated_sprite_2d.play("hurt")
	
	

func handle_death_animation():
	$CollisionShape2D.position.y = 5
	animated_sprite_2d.play("hurt")
	await get_tree().create_timer(0.5).timeout
	for i in range(100):
		$Camera2D.zoom.x += .01
		$Camera2D.zoom.y += .01
		await get_tree().create_timer(0.01).timeout
	
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://Scenes/main menu.tscn")

func take_damage_cooldown(wait_time):
	can_take_damage = false
	await get_tree().create_timer(wait_time).timeout
	can_take_damage = true

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
		wait_time = .8
	elif attack_type == "single":
		wait_time = .8
	elif attack_type == "heavy":
		wait_time = 1
	damage_zone_collision.disabled = false
	await get_tree().create_timer(wait_time).timeout
	damage_zone_collision.disabled = true


func _on_animated_sprite_2d_animation_finished():
	current_attack = false
	
func set_damage(attack_type):
	var current_damage_to_deal: int
	if attack_type == "single":
		current_damage_to_deal = 8
	elif attack_type == "heavy":
		current_damage_to_deal = 20
	elif attack_type == "air":
		current_damage_to_deal = 10
	Global.playerDamageAmount = current_damage_to_deal
