extends Control

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("mostrar_logos")

func iniciar_juego():
	get_tree().change_scene_to_file("res://escenas/menu_principal.tscn")
