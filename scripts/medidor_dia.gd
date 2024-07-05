extends Node2D

var es_de_dia = true
@onready var animador = $AnimationPlayer
@onready var etiqueta_turno = $Numero_turno

signal animation_finished()

# Called when the node enters the scene tree for the first time.
func _ready():
	animador.play("hacer_de_noche")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hacer_de_noche():
	if es_de_dia:
		animador.play("hacer_de_noche")
		es_de_dia = false

func hacer_de_dia():
	if !es_de_dia:
		animador.play("hacer_de_dia")
		es_de_dia = true

func actualizar_turno(turno : int):
	etiqueta_turno.text = str(turno)

func _on_animation_player_animation_finished(anim_name):
	await get_tree().create_timer(0.5).timeout
	animation_finished.emit()
