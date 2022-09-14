extends VBoxContainer

func _ready():
	pass

#@see https://docs.godotengine.org/de/stable/getting_started/step_by_step/signals.html#custom-signals
func _on_Button_start_pressed():
	get_tree().change_scene("res://scenes/Level1Intro.tscn")
