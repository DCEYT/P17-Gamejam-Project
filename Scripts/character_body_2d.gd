extends CharacterBody2D

class_name Player11

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var deal_damage_zone = $DealDamageZone
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var walk_sound: AudioStreamPlayer2D = $WalkSound
@onready var dash_sound: AudioStreamPlayer2D = $DashSound
@onready var run_sound: AudioStreamPlayer2D = $RunSound
@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var whoosh_sound: AudioStreamPlayer2D = $WhooshSound
@onready var whoosh_sound_2: AudioStreamPlayer2D = $WhooshSound2
@onready var falling_sound: AudioStreamPlayer2D = $FallingSound
@onready var attackanim: AnimatedSprite2D = $DealDamageZone/AnimatedSprite2D


signal healthChange

const SPEED = 700
const JUMP_VELOCITY = -1100

const RUN_SPEED = 1400
const DOWN_SPEED = 1100
const DASH_SPEED = 3000
var running = false
var dashing = false
var jumping = false
var falling = false
var can_dash = true
var knockback = false

var attack_type: String
var current_attack: bool

const gravity = 1100

var health = 100
var health_max = 100
var health_min = 0
var can_take_damage: bool
var dead: bool
var knockback_force = -10000

var Enemy: CharacterBody2D
var enemy: CharacterBody2D

func _ready():
	Global.playerBody = self
	current_attack = false
	dead = false
	can_take_damage = true
	Global.playerAlive = true

func _physics_process(delta: float) -> void:
	Global.playerDamageZone = deal_damage_zone
	Global.playerHitbox = $PlayerHitbox
	if Global.talkedJacque and !Global.talkedMartha and !Global.talkedDoor:
		enemy = Global.JacqueBody
	elif Global.talkedJacque and Global.talkedMartha and !Global.talkedDoor:
		enemy = Global.MarthaBody
	elif Global.talkedJacque and Global.talkedMartha and Global.talkedDoor:
		enemy = Global.BigBossBody
	
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if !dead:
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jumping = true
			animated_sprite_2d.play("jump")
			jump_sound.play()
			if run_sound.playing or walk_sound.playing:
				run_sound.stop()
				walk_sound.stop()
			handle_jumping_please()

		

		if Input.is_action_just_pressed("Move Down") and not is_on_floor():
			if velocity.y < 0:
				velocity.y = 0
			velocity.y += DOWN_SPEED

		if velocity.y > 110:
			falling = true
			if !current_attack and falling == true:
				animated_sprite_2d.play("fall")
				if !falling_sound.playing:
					falling_sound.play()
		if is_on_floor():
			falling = false
			falling_sound.stop()
		
		if Input.is_action_just_pressed("Dash") and can_dash:
			dashing = true
			can_dash = false
			print("dash")
			$Dash_Timer.start()
			$Can_Dash_Timer.start()
			dash_sound.play()
		
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
		if !knockback and direction:
			if dashing: 
				if !current_attack and can_take_damage:
					animated_sprite_2d.play("dash")
				velocity.x = direction * DASH_SPEED
			elif running:
				if !falling and !jumping and !current_attack and can_take_damage:
					animated_sprite_2d.play("run")
				if is_on_floor():
					if walk_sound.playing:
						walk_sound.stop()
					if !run_sound.playing:
						run_sound.play()
				else:
					run_sound.stop()
				velocity.x = direction * RUN_SPEED
			elif !running and !dashing:
				if !falling and !jumping and !current_attack and can_take_damage:
					animated_sprite_2d.play("walk")
				velocity.x = direction * SPEED
				if is_on_floor():
					if run_sound.playing:
						run_sound.stop()
					if !walk_sound.playing:
						walk_sound.play()
				else:
					walk_sound.stop()
		else:
			if !falling and !jumping and !current_attack and can_take_damage:
				animated_sprite_2d.play("idle")
			walk_sound.stop()
			run_sound.stop()
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
		
		
		if !current_attack:
			if Input.is_action_just_pressed("Attack") or Input.is_action_just_pressed("Attack2"):
				current_attack = true
				if Input.is_action_just_pressed("Attack") and is_on_floor():
					attack_type = "single"
					whoosh_sound.play()
				elif Input.is_action_just_pressed("Attack2") and is_on_floor():
					attack_type = "heavy"
					whoosh_sound_2.play()
				else:
					attack_type = "air"
					whoosh_sound.play()
				
				set_damage(attack_type)
				handle_attack_animation(attack_type)
				handle_other_attack(attack_type)
			check_hitbox()
	move_and_slide()

		

func handle_jumping_please():
	falling = false
	while jumping:
		if velocity.y >= 0 and falling == false:
			falling = true
			animated_sprite_2d.play("fall")
		await get_tree().create_timer(0.01).timeout
		if jumping and is_on_floor():
			jumping = false
			falling = false

func check_hitbox():
	var hitbox_area = $PlayerHitbox.get_overlapping_areas()
	var damage: int
	if hitbox_area:
		var hitbox = hitbox_area.front()
		if hitbox.get_parent() is Jacque:
			damage = Global.JacqueDamageAmount
		if hitbox.get_parent() is Martha:
			damage = Global.MarthaDamageAmount
		if hitbox.get_parent() is BigBoss:
			damage = Global.BigBossDamageAmount
		if hitbox.get_parent() is Bullet:
			damage = Global.BulletDamageAmount
		if hitbox.get_parent() is MBullet:
			damage = Global.MBulletDamageAmount
		if hitbox.get_parent() is BBBullet:
			damage = Global.BBBulletDamageAmount
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
		healthChange.emit()
		take_damage_cooldown(1.0)

func handle_hurt_animation():
	hurt_sound.play()
	animated_sprite_2d.play("hurt")
	knockback = true
	var knockback_dir = position.direction_to(enemy.position) * knockback_force
	print(knockback_dir)
	print(knockback_dir[0])
	if knockback_dir[0] <= 0:
		knockback_dir = -400
	elif knockback_dir[0] >= 0:
		knockback_dir = 400
	velocity.x = 0
	for i in range(25):
		velocity.x += knockback_dir
		await get_tree().create_timer(0.0025).timeout
	framefreeze(0.05, 0.25)
	for i in range(25):
		velocity.x += knockback_dir
		await get_tree().create_timer(0.0025).timeout
	await get_tree().create_timer(0.3).timeout
	knockback = false

	
	

func handle_death_animation():
	animated_sprite_2d.play("hurt")
	hurt_sound.play()
	await get_tree().create_timer(0.3).timeout
	$CollisionShape2D.position.y = 5
	death_sound.play()
	animated_sprite_2d.play("death")
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
		toggle_damage_collisions(attack_type)

func handle_other_attack(attack_type):
	var animation = str(attack_type, "_attack")
	attackanim.play(animation)

func toggle_damage_collisions(attack_type):
	var damage_zone_collision = deal_damage_zone.get_node("CollisionShape2D")
	var wait_time: float
	if attack_type == "air":
		wait_time = .3
	elif attack_type == "single":
		wait_time = .3
	elif attack_type == "heavy":
		wait_time = .9
	await get_tree().create_timer(wait_time).timeout
	damage_zone_collision.disabled = false
	await get_tree().create_timer(.3).timeout
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

func framefreeze(timeScale, duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1
