extends Node2D

@onready var animador = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	$Sprite2D.scale = Vector2(0.5, 0.5)

func mostrar_alerta_combo():
	self.visible = true
	animador.play("zoom")
	await animador.animation_finished
	self.visible = false
	$Sprite2D.scale = Vector2(0.5, 0.5)
