extends Node2D

var baraja_cartas = []
var mano = []
var cartas_a_jugar = []

@export var n_cartas_turno = 2

signal cartas_seleccionadas(cartas_a_jugar)

func _ready():
	baraja_cartas = get_children()
	for carta in baraja_cartas:
		carta.jugar_carta.connect(carta_jugada)
		carta.desjugar_carta.connect(desjugar_carta)

func barajar_cartas(num_cartas : int , nivel_locura : int, b_ia : bool):
	mano = []
	while (mano.size() < num_cartas):
		var carta_elegida = baraja_cartas.pick_random()
		if carta_elegida.es_jugable(nivel_locura, b_ia):
			mano.append(carta_elegida)
			carta_elegida.set_carta_usada(true) # para que no salgan cartas repetidas en una mano
	for carta in mano:
		carta.set_carta_usada(false) # para que las cartas que no se usen vuelvan a la baraja en el siguiente turno??

func debug_print_valor_medio(array):
	var n_cartas = array.size()
	var valor_total = 0
	for carta in array:
		valor_total += carta.valor
	print("			El valor medio de estas cartas es: ", valor_total/n_cartas)

func debug_print_array_cartas(array):
	for carta in array:
		print(carta.titulo)

func carta_jugada(carta):
	cartas_a_jugar.append(carta)
	if cartas_a_jugar.size() == n_cartas_turno:
		cartas_seleccionadas.emit(cartas_a_jugar)
		cartas_a_jugar = []
func desjugar_carta(_carta):
	cartas_a_jugar.pop_back()
