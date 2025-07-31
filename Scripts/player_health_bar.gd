extends TextureProgressBar

@export var player: Player11

func _ready():
	player.healthChange.connect(update)
	update()

func update():
	value = player.health * 100 / player.health_max
	
