extends Control

@onready var carta_arriba = false
@onready var carta_jugada = false
@onready var descripcion = $descripcion
@onready var carta = $carta
@onready var pos_ini = position

# Called when the node enters the scene tree for the first time.
func _ready():
	descripcion.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_carta_mano_mouse_entered():
	subir_carta()
	carta_arriba = true
	descripcion.visible = true

func _on_carta_mano_mouse_exited():
	if carta_jugada:
		pass
	else:
		bajar_carta()
		carta_arriba = false
		descripcion.visible = false

func subir_carta():
	position = pos_ini + Vector2.UP * 80

func bajar_carta():
	position = pos_ini

func ocultar_carta(no_jugadas : bool):
	# false para ocultar todas las cartas
	# true para ocultar solo las no jugadas
	if no_jugadas and carta_jugada:
		pass
	else:
		position = pos_ini + Vector2.UP * -500
		descripcion.visible = false

func subir_carta_mas ():
	position = pos_ini + Vector2.UP * 200

func _on_carta_mano_pressed():
	carta_jugada = true
	subir_carta_mas()
	self.carta.jugar()

func actualizar_descripcion():
	descripcion.find_child("titulo").text = self.carta.titulo
	descripcion.find_child("descripcion").text = self.carta.descripcion

func set_carta(_carta):
	carta_jugada = false
	self.carta = _carta
	actualizar_descripcion()
