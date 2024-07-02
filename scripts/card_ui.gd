extends Control

@onready var cartas = []

func _ready():
	cartas = get_children()

func colocar_cartas_en_mano(mano):
	ocultar_cartas(false)
	var n = mano.size()
	for i in range(n):
		cartas[i].set_carta(mano[i])
	await get_tree().create_timer(1.0).timeout
	mostrar_cartas()

func mostrar_cartas():
	for i in cartas:
		i.bajar_carta()

func ocultar_cartas(no_jugadas : bool):
	# false para ocultar todas las cartas
	# true para ocultar solo las no jugadas
	for i in cartas:
		i.ocultar_carta(no_jugadas)
