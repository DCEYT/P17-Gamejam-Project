extends TextureProgressBar

@export var enemy: BigBoss

func _ready():
	enemy.healthChanged.connect(update)
	update()

func update():
	value = enemy.health * 100 / enemy.health_max
	
