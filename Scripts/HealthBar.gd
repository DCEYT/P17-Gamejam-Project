extends ProgressBar

@export var enemy: Jacque

func _ready():
	enemy.healthChanged.connect(update)
	update()

func update():
	value = enemy.health * 100 / enemy.health_max
	
	
