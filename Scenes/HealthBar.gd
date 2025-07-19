extends ProgressBar

@export var enemy: Enemy11

func _ready():
	enemy.healthChanged.connect(update)
	update()

func update():
	value = enemy.health * 100 / enemy.health_max
	
	
