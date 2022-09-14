extends Spatial

onready var animation_player = get_node("/root/Level1Intro/CanvasLayer/AnimationPlayer")

func _ready():
	animation_player.play("IntroTextFade")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://scenes/Weltraum.tscn")
