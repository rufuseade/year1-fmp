extends Light2D


onready var noise = OpenSimplexNoise.new()
var value = 0.0
const MAX_VALUE = 10000000

func _ready():
	randomize()
	value = randi() % MAX_VALUE
	noise.period = 16
	
func _physics_process(delta):
	value += 0.5
	if(value > MAX_VALUE):
		value = 0.0
	var alpha = ((noise.get_noise_1d(value) + 1) / 1.0) + 1
	
	self.color = Color(color.r, color.g, color.b, alpha)
