extends Node2D

class_name Bullet

const speed = 3000
@onready var sprite_2d: Sprite2D = $Sprite2D
var damage_to_deal = 10


func _ready():
	Global.BulletBody = self

func _process(delta):
	position += transform.x * speed * delta
	sprite_2d.rotation_degrees += .1
	Global.BulletDamageZone = $BulletDealDamage
	Global.BulletDamageAmount = damage_to_deal
	if !Global.JacqueAlive:
		self.queue_free()



func _on_kill_timer_timeout() -> void:
	self.queue_free()


func _on_bullet_deal_damage_area_entered(area: Area2D) -> void:
	pass
