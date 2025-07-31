extends Node2D

class_name MBullet

const speed = 2000
var damage_to_deal = 15
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	Global.MBulletBody = self

func _process(delta):
	position += transform.x * speed * delta
	sprite_2d.rotation_degrees += .1
	Global.MBulletDamageZone = $BulletDealDamage
	Global.MBulletDamageAmount = damage_to_deal
	if !Global.MarthaAlive:
		self.queue_free()



func _on_kill_timer_timeout() -> void:
	self.queue_free()


func _on_bullet_deal_damage_area_entered(area: Area2D) -> void:
	pass
