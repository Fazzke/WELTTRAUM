extends RigidBody

onready var centralStar = get_node("/root/Weltraum/aerial_rocks/RigidBody")
onready var planet1 = get_node("/root/Weltraum/StaticBody")
onready var planet2 = get_node("/root/Weltraum/StaticBody2")
onready var planet3 = get_node("/root/Weltraum/StaticBody3")
var planets = []
var gravity_direction = Vector3();
var move_force = 550
var jump_force = 40
var current_planet = null
var inside_planets = false;

func _ready():
	planets = [planet1, planet2, planet3]
	current_planet = centralStar
	_calc_gravity_direction(current_planet)

func _process(delta):
	_calc_gravity_direction(current_planet)
	prevent_player_from_falling()
	_move()

func _physics_process(delta):
	_calc_gravity_direction(current_planet)

func _calc_nearest_planet(planets):
	#Sind die Begrenzungspunkte der Strecke P1(x1, y1, z1) und P2(x2,y2,z2), dann gilt für die Länge s der Strecke:
	#s2 = (x2-x1)2+(y2-y1)2+(z2-z1)2
	print(current_planet.distance_to_player)
	for planet in planets:
		planet.distance_to_player = abs(((planet.transform.origin.x - transform.origin.x) * 2) + ((planet.transform.origin.y - transform.origin.y) * 2) + ((planet.transform.origin.z - transform.origin.z) * 2) * 1.0000)
		
		if current_planet == null:
			current_planet = planet
		else:
			if planet.distance_to_player <= current_planet.distance_to_player:
				current_planet = planet
		print(planet.distance_to_player)
	print(current_planet.planet_name)

func _integrate_forces(state):
	_walk_around_planet(state)
	

func _calc_gravity_direction(planet_node):
	gravity_direction = (planet_node.transform.origin - transform.origin).normalized()

func _walk_around_planet(state):
	# allign the players y-axis (up and down) with the planet's gravity direciton:
	if current_planet != centralStar:
		state.transform.basis.y = -gravity_direction
		
func prevent_player_from_falling():
	#apply_impulse(Vector3(0, 1, 0), Vector3(0, 1, 0))
	#apply_impulse(Vector3(0, -1, 0), Vector3(0, -1, 0))
	if current_planet == centralStar:
		set_linear_velocity(Vector3(0, 0, 0))
	else:
		set_linear_velocity(gravity_direction * 10)

func _on_Area_body_entered(body):
	_calc_nearest_planet(planets)
	inside_planets = true
	print("Area entered")
	
func _on_Area_body_exited(body):
	if inside_planets == false:
		current_planet = centralStar
	print("Area exited")

func _move():
	if Input.is_action_pressed("ui_backwards"):
		add_central_force(move_force * global_transform.basis.z)
		
	if Input.is_action_pressed("ui_forwards"):
		add_central_force(move_force * -global_transform.basis.z)

	if Input.is_action_pressed("ui_right"):
		add_central_force(move_force * global_transform.basis.x)
		#slightly rotate left
		#rotate_y(-0.01)
		rotate_object_local(Vector3.DOWN, 0.01)

	if Input.is_action_pressed("ui_left"):
		add_central_force(move_force * -global_transform.basis.x)
		#rotate_y(0.01)
		rotate_object_local(Vector3.UP, 0.01)
		
	if Input.is_action_pressed("ui_up"):
		#rotate_x(0.01)
		rotate_object_local(Vector3.LEFT, 0.01)
		
	if Input.is_action_pressed("ui_down"):
		#rotate_x(-0.01)
		rotate_object_local(Vector3.RIGHT, 0.01)
	
	#jump:
	if Input.is_action_pressed("ui_space"):
		apply_impulse(Vector3.UP, jump_force * global_transform.basis.y)
		#add_force(Vector3.UP, jump_force * global_transform.basis.y)

#func _calc_nearest_planet(planet1, planet2, planet3):
#	#Sind die Begrenzungspunkte der Strecke P1(x1, y1, z1) und P2(x2,y2,z2), dann gilt für die Länge s der Strecke:
#	#s2 = (x2-x1)2+(y2-y1)2+(z2-z1)2
#	var planet1_to_player_distance = abs(((planet1.transform.origin.x - transform.origin.x) * 2) + ((planet1.transform.origin.y - transform.origin.y) * 2) + ((planet1.transform.origin.z - transform.origin.z) * 2) * 1.0000)
#	var planet2_to_player_distance = abs(((planet2.transform.origin.x - transform.origin.x) * 2) + ((planet2.transform.origin.y - transform.origin.y) * 2) + ((planet2.transform.origin.z - transform.origin.z) * 2) * 1.0000)
#	var planet3_to_player_distance = abs(((planet3.transform.origin.x - transform.origin.x) * 2) + ((planet3.transform.origin.y - transform.origin.y) * 2) + ((planet3.transform.origin.z - transform.origin.z) * 2) * 1.0000)
#
#	print(planet1_to_player_distance)
#	print(planet2_to_player_distance)
#	print(planet3_to_player_distance)
#
#	if planet1_to_player_distance <= planet2_to_player_distance:
#		if planet1_to_player_distance <= planet3_to_player_distance:
#			current_planet = planet1
#			print("Current planet: 1")
#		else:
#			current_planet = planet3
#			print("Current planet: 3")
#	elif planet1_to_player_distance >= planet2_to_player_distance:
#		if planet2_to_player_distance <= planet3_to_player_distance:
#			current_planet = planet2
#			print("Current planet: 2")
#		else:
#			current_planet = planet3
#			print("Current planet: 3")
