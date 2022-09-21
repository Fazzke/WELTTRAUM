extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().change_scene("res://scenes/HUD.tscn")

#func _process(delta):
#	pass

func change_to_end_screen():
	get_tree().change_scene("res://scenes/GameOverScreen.tscn")
	pass

