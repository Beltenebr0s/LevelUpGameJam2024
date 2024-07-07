extends Control

@onready var animation_player = $AnimationPlayer

@export var siguiente_escena : PackedScene

func fade_in():
	print("empieza fade in")
	self.visible = true
	animation_player.play("fade_in")

func ocultar_fade():
	print("acaba fade in")
	self.visible = false

func fade_out():
	print("empieza fade out")
	self.visible = true
	animation_player.play("fade_out")

func cambiar_escena():
	print("acaba fade out")
	get_tree().change_scene_to_packed(siguiente_escena)

