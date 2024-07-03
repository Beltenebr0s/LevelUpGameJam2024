extends Control

@onready var cartas = []
@onready var mano_lista = false

func _ready():
	cartas = get_children()

func colocar_cartas_en_mano(mano):
	ocultar_cartas(false)
	var n = mano.size()
	for i in range(n):
		cartas[i].set_carta(mano[i])
	await get_tree().create_timer(1.0).timeout
	mostrar_cartas()
	mano_lista = true

func mostrar_cartas():
	for i in cartas:
		i.bajar_carta()

func ocultar_cartas(no_jugadas : bool):
	# false para ocultar todas las cartas
	# true para ocultar solo las no jugadas
	mano_lista = false
	for i in cartas:
		i.ocultar_carta(no_jugadas)
