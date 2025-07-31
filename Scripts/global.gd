extends Node

var playerBody: CharacterBody2D
var JacqueBody: CharacterBody2D
var MarthaBody: CharacterBody2D
var BigBossBody: CharacterBody2D
var BulletBody: Node2D
var MBulletBody: Node2D
var BBBulletBody: Node2D


var playerAlive: bool
var playerDamageZone: Area2D
var playerDamageAmount: int
var playerHitbox: Area2D

var JacqueDamageZone: Area2D
var JacqueDamageAmount: int

var BulletDamageZone: Area2D
var BulletDamageAmount: int
var BulletHitbox: Area2D

var MBulletDamageZone: Area2D
var MBulletDamageAmount: int
var MBulletHitbox: Area2D

var BBBulletDamageZone: Area2D
var BBBulletDamageAmount: int
var BBBulletHitbox: Area2D

var MarthaDamageZone: Area2D
var MarthaDamageAmount: int

var BigBossDamageZone: Area2D
var BigBossDamageAmount: int

var JacqueAlive = true
var MarthaAlive = true
var BigBossAlive = true

var talkedJacque = false
var talkedMartha = false
var talkedDoor = false

var point = 0
