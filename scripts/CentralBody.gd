extends StaticBody

export var distance_to_player = 1000000.0000
export var planet_name = "Central"

var timer = null

func _ready():
	timer = Timer.new()
	timer.set_wait_time(1.0)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "repeat_grow")
	add_child(timer)
	timer.start()
	
func repeat_grow():
	var current_scale = get_scale()
	set_scale(current_scale * 1.001)
	print("Black Hole Grown!")


