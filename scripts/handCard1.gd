extends Button

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


func _on_mouse_entered():
	animation_player.play("card_up")
	card_is_up = true
	descripcion.visible = true
	pass 

func _on_mouse_exited():
	animation_player.play_backwards("card_up")
	card_is_up = false
	descripcion.visible = false
	pass  

func _on_pressed():
	pass # Replace with function body.
