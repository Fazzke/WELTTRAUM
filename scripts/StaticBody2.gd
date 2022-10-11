extends StaticBody

export var distance_to_player = 0.0000
export var planet_name = "Browny"
onready var player = get_node("/root/Weltraum/RigidBodyPlayer")
onready var central = get_node("/root/Weltraum/Central")
var is_body_inside_area = false
var on_planet_ground = false

var angle = 0.0
var speed = 0.0012
var central_position = Vector3()
var self_position = Vector3()
var new_pos = Vector3()

func _ready():
	central_position = central.get_translation()
	self_position = self.get_translation()
	
func _process(delta):
	rotation_orbit(delta)
	# constant speed of the orbiting planet
	angle += speed

func rotation_orbit(delta):
	new_pos.x = self_position.x * cos(angle) - self_position.z * sin(angle)
	new_pos.y = self_position.y
	new_pos.z = self_position.x * sin(angle) + self_position.z * cos(angle)
	
	new_pos = new_pos + central_position
	
	self.set_translation(new_pos)

func _on_Area_body_entered(body):
	is_body_inside_area = true
	#print(planet_name)
	player.current_planet = self
	pass # Replace with function body.

func _on_Area_body_exited(body):
	is_body_inside_area = false
	pass # Replace with function body.


func _on_PlanetGroundArea_body_entered(body):
	on_planet_ground = true
	pass # Replace with function body.

func _on_PlanetGroundArea_body_exited(body):
	on_planet_ground = false
	pass # Replace with function body.
