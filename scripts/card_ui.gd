extends Control

@export var cartas_ia = false
@onready var cartas = []
@onready var mano_lista = false

signal play_sonido_carta

func _ready():
	cartas = get_children()
	for i in cartas:
		i.play_sonido.connect(_on_play_sonido_play_sonido_carta)
		if cartas_ia:
			i.mano_ia()

func colocar_cartas_en_mano(mano):
	ocultar_cartas(false)
	var n = mano.size()
	for i in range(n):
		cartas[i].set_carta(mano[i])
	mostrar_cartas()
	mano_lista = true

func colocar_cartas_en_mano_mulligan(mano):
	ocultar_cartas(true)
	var n = mano.size()
	for i in range(n):
		if !cartas[i].carta_jugada:
			cartas[i].set_carta(mano[i])
			cartas[i].mostrar_carta()
	mano_lista = true

func mostrar_cartas():
	for i in cartas:
		i.mostrar_carta()

func ocultar_cartas(no_jugadas : bool):
	# false para ocultar todas las cartas
	# true para ocultar solo las no jugadas
	mano_lista = false
	for carta in cartas:
		carta.ocultar_carta(no_jugadas)

func _on_play_sonido_play_sonido_carta():
	play_sonido_carta.emit()
