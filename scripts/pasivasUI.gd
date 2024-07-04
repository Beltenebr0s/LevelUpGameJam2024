extends Control

@onready var cartas_pasivas = []

signal mulligan()
signal play_sonido_carta

# Called when the node enters the scene tree for the first time.
func _ready():
	cartas_pasivas = get_children()
	for carta in cartas_pasivas:
		carta.carta_seleccionada.connect(_on_carta_seleccionada)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func desactivar(n : int):
	# -1 para ocultar todas
	# i para ocultar la i-esima
	if n == -1:
		for i in cartas_pasivas:
			i.ocultar_icono()
	else:
		cartas_pasivas[n].ocultar_icono()

func activar(n : int):
	# -1 para mostrar todas
	# i para mostrar la i-esima
	if n == -1:
		for i in cartas_pasivas:
			i.mostrar_icono()
	else:
		cartas_pasivas[n].mostrar_icono()

func pasiva_activada(n : int):
	# devuelve true si la pasiva está activada
	return cartas_pasivas[n].visible

func _on_sacerdote_accion():
	mulligan.emit()
	
func _on_carta_seleccionada():
	play_sonido_carta.emit()
