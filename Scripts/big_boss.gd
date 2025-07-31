extends CharacterBody2D

class_name BigBoss

signal healthChanged

#the bullets
const bullet_scene = preload("res://Scenes/bb_bullet.tscn")
const speed = 400
var rotate_speed = 100
var shoot_timer_wait_time = .4
var spawn_point_count = 4
const radius = 100

@onready var shoot_timer = $ShootTimer
@onready var rotater = $Rotater

@onready var enemy_1_deal_damage_area: Area2D = $BBDealDamageArea
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var gettinghitsound: AudioStreamPlayer2D = $gettinghitsound
@onready var gettinghitsound_2: AudioStreamPlayer2D = $gettinghitsound2
@onready var gettinghitsound_3: AudioStreamPlayer2D = $gettinghitsound3
@onready var animated_sprite_2d = $BBDealDamageArea/AnimatedSprite2D
@onready var anim_sprite = $AnimatedSprite2D

var is_enemy_chase: bool = true

var health = 400
var health_max = 400
var health_min = 0

var dead: bool = false
var taking_damage: bool = false
var damage_to_deal = 20
var is_dealing_damage: bool = false
var phase1: bool = false
var phase2: bool = false
var phase_end: bool = false
var jumping = false

var dir: Vector2
const gravity = 900
var knockback_force = -300
var is_roaming: bool = true
var throw = false

var player: CharacterBody2D
var player_in_area = false

func _ready():
	Global.BigBossBody = self
	
func _process(delta):
	
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
		
	Global.BigBossDamageAmount = damage_to_deal
	Global.BigBossDamageZone = $BBDealDamageArea
	player = Global.playerBody
	
	if Global.playerAlive:
		is_enemy_chase = true
	elif !Global.playerAlive:
		is_enemy_chase = false
	
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)
	
	if !phase1 and health <= 200:
		phase_end = true
		var step = 2 * PI / spawn_point_count
		phase1 = true
		
		for i in range(spawn_point_count):
			var spawn_point = Node2D.new()
			var pos = Vector2(radius, 0).rotated(step * 1)
			spawn_point.position = pos
			spawn_point.rotation = pos.angle()
			rotater.add_child(spawn_point)
			
		shoot_timer.wait_time = shoot_timer_wait_time
		shoot_timer.start()
	
	if phase_end and health <= 110:
		phase_end = false
		shoot_timer.stop()
	
	if phase1 and !phase2 and health <= 100:
		
		var rotate_speed = 500
		var shoot_timer_wait_time = .2
		var spawn_point_count = 12
		
		var step = 2 * PI / spawn_point_count
		phase2 = true
		
		for i in range(spawn_point_count):
			var spawn_point = Node2D.new()
			var pos = Vector2(radius, 0).rotated(step * 1)
			spawn_point.position = pos
			spawn_point.rotation = pos.angle()
			rotater.add_child(spawn_point)
			
		shoot_timer.wait_time = shoot_timer_wait_time
		shoot_timer.start()
	
		
	
	move(delta)
	handle_animation()
	move_and_slide()
	
func handle_jumping():
	jumping = true
	await get_tree().create_timer(10).timeout
	velocity.y = -1000
	jumping = false
	
func move(delta):
	if !dead:
		if !is_enemy_chase:
			velocity += dir * speed * delta
		elif is_enemy_chase and !taking_damage and Global.playerAlive:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x 
			dir.x = abs(velocity.x) / velocity.x
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * knockback_force
			velocity.x = knockback_dir.x
		is_roaming = true
	elif dead:
		velocity.x = 0

func handle_animation():
	if !dead and !taking_damage and !is_dealing_damage and !throw:
		animated_sprite_2d.visible = false
		anim_sprite.play("walk")
		if dir.x == -1:
			anim_sprite.flip_h = false
			enemy_1_deal_damage_area.scale.x = 1
		elif dir.x == 1:
			anim_sprite.flip_h = true
			enemy_1_deal_damage_area.scale.x = -1

	elif !dead and taking_damage and !is_dealing_damage:
		handle_hurt_please()
	elif dead and is_roaming and !throw:
		is_roaming = false
		gettinghitsound_3.play()
		anim_sprite.play("death")
		await get_tree().create_timer(2).timeout
		handle_death()
		
	elif !dead and is_dealing_damage:
		anim_sprite.play("enemy attack")
		animated_sprite_2d.visible = true
		
	
func handle_hurt_please():
	var anim_sprite = $AnimatedSprite2D
	anim_sprite.play("hurt")
	await get_tree().create_timer(.4).timeout
	taking_damage = false
	
func handle_death():
	Global.BigBossAlive = false
	self.queue_free()
	Global.point += 1
	get_tree().change_scene_to_file("res://Scenes/you're_promoted.tscn")
	

func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.5,2,2.5])
	if !is_enemy_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0
	
func choose(array):
	array.shuffle()
	return array.front()
		
func take_damage(damage):
	if damage == 8:
		gettinghitsound.play()
	elif damage == 20:
		gettinghitsound_2.play()
	health -= damage
	taking_damage = true
	healthChanged.emit()
	if health <= health_min:
		health = health_min	
		dead = true




func _on_shoot_timer_timeout() -> void:
	if !taking_damage:
		throw = true
		anim_sprite.play("throw")
		for s in rotater.get_children():
			var bullet = bullet_scene.instantiate()
			get_tree().root.add_child(bullet)
			bullet.position = s.global_position
			bullet.rotation = s.global_rotation
		throw = false
		


func _on_bb_hitbox_area_entered(area: Area2D) -> void:
	var damage = Global.playerDamageAmount
	if area == Global.playerDamageZone:
		take_damage(damage)




func _on_bb_deal_damage_area_area_entered(area: Area2D) -> void:
	if area == Global.playerHitbox:
		is_dealing_damage = true
		hit_sound.play()
		await get_tree().create_timer(.4).timeout
		is_dealing_damage = false
