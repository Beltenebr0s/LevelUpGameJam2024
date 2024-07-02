extends Node2D

var baraja_cartas = []
var nivel_locura = 50
var mano = []

func _ready():
	baraja_cartas = get_children()
	barajar_cartas(3)

func barajar_cartas(num_cartas : int):
	mano = []
	while (mano.size() < num_cartas):
		var carta_elegida = baraja_cartas.pick_random()
		if carta_elegida.es_jugable(nivel_locura):
			mano.append(carta_elegida)
			carta_elegida.set_carta_usada(true) # para que no salgan cartas repetidas en una mano
	print("Cartas en la mano: ")
	debug_print_array_cartas(mano)
	for carta in mano:
		carta.set_carta_usada(false) # para que las cartas que no se usen vuelvan a la baraja en el siguiente turno??
	
func debug_print_array_cartas(array):
	for carta in array:
		print(carta.titulo)
