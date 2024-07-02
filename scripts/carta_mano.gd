extends Control

@onready var card_is_up : bool = false
@onready var descripcion : Sprite2D = find_child("descripcion")
@onready var animation_player = find_child("AnimationPlayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	descripcion.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_carta_mano_mouse_entered():
	# animation_player.play("card_up")
	position += Vector2.UP * 80
	card_is_up = true
	descripcion.visible = true
	pass 

func _on_carta_mano_mouse_exited():
	# animation_player.play_backwards("card_up")
	card_is_up = false
	descripcion.visible = false
	position += Vector2.UP * -80
	pass  

func _on_carta_mano_pressed():
	pass # Replace with function body.

func actualizar_descripcion():
	descripcion.find_child("titulo").text = find_child("carta").titulo
	descripcion.find_child("descripcion").text = find_child("carta").descripcion
	pass
