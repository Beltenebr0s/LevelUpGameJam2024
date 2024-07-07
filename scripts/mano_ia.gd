extends Node2D

var cartas_en_mano = []
var mano = []
var mano_lista = false
var n_cartas_turno = 1
var prob_counter : float = 0.25

func _ready():
	cartas_en_mano = get_children()

func colocar_cartas_en_mano(_mano):
	ocultar_cartas(false)
	mano = _mano
	mostrar_cartas()
	mano_lista = true

func mostrar_cartas():
	for hueco_carta in cartas_en_mano:
		hueco_carta.mostrar_carta()

func ocultar_cartas(no_jugadas : bool):
	# false para ocultar todas las cartas
	# true para ocultar solo las no jugadas
	mano_lista = false
	for hueco_carta in cartas_en_mano:
		hueco_carta.ocultar_carta(no_jugadas)

func animar_mano():
	var cartas_escogidas = []
	var carta_uno = randi() % cartas_en_mano.size()
	var carta_dos = randi() % cartas_en_mano.size()
	while carta_dos == carta_uno || carta_dos + 1 == carta_uno || carta_dos - 1 == carta_uno:
		carta_dos = randi() % cartas_en_mano.size()
		
	cartas_en_mano[carta_uno].seleccionar_carta()
	cartas_en_mano[carta_dos].seleccionar_carta()
	cartas_escogidas.append(cartas_en_mano[carta_uno])
	cartas_escogidas.append(cartas_en_mano[carta_dos])
	
	#while cartas_escogidas.size() < mano.size():
	#	var hueco_carta = cartas_en_mano.pick_random()
	#	if hueco_carta.carta_jugada:
	#		pass
	#	else:
	#		hueco_carta.seleccionar_carta()
	#		cartas_escogidas.append(hueco_carta)
	ocultar_cartas(true)
	Audio.play_jugar_carta()
	for i in range(cartas_escogidas.size()):
		cartas_escogidas[i].mostrar_descripcion(mano[i].titulo, mano[i].descripcion)

