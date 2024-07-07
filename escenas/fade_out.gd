extends Control

@onready var animation_player = $AnimationPlayer
@onready var sprite_diablillo = $Fondo/Sprite2D
@onready var fondo = $Fondo

var siguiente_escena : PackedScene


func fade_in(_diablillo_on):
	print("empieza fade in")
	if !_diablillo_on:
		self.sprite_diablillo.visible = false
	self.fondo.modulate = Color(1,1,1,1)
	self.visible = true
	animation_player.play("fade_in")
	await animation_player.animation_finished
	self.sprite_diablillo.visible = true

func ocultar_fade():
	print("acaba fade in")
	self.visible = false

func fade_out():
	print("empieza fade out")
	self.fondo.modulate = Color(1,1,1,0)
	self.visible = true
	animation_player.play("fade_out")

func cambiar_escena():
	print("acaba fade out")
	get_tree().change_scene_to_packed(siguiente_escena)

func set_siguiente_escena(escena : PackedScene):
	siguiente_escena = escena
