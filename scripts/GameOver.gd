extends CenterContainer

func _ready():
	pass 

func _on_Button_game_menu_pressed():
	get_tree().change_scene("res://scenes/HUD.tscn")
