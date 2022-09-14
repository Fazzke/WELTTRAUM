extends StaticBody

export var distance_to_player = 0.0000
export var planet_name = "Purply"
onready var player = get_node("/root/Weltraum/RigidBodyPlayer")
var is_body_inside_area = false
var on_planet_ground = false

func _ready():
	pass # Replace with function body.

func get_distance_to_player():
	return distance_to_player

func set_distance_to_player(distance):
	distance_to_player = distance

func _on_Area_body_entered(body):
	print(planet_name)
	is_body_inside_area = true
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
