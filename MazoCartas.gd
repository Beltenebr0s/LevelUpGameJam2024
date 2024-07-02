extends Node2D

var baraja_cartas = []
var nivel_locura = 50
func _ready():
	baraja_cartas = get_children()
	#debug_print_array_cartas(baraja_cartas)
	
	barajar_cartas(3)

func barajar_cartas(num_cartas : int):
	var mano = []
	while (mano.size() < num_cartas):
		var carta_elegida = baraja_cartas.pick_random()
		if carta_elegida.es_jugable(nivel_locura):
			mano.append(carta_elegida)
			carta_elegida.usar_carta()
			
			
	print("Cartas en la mano: ")
	debug_print_array_cartas(mano)
	
func debug_print_array_cartas(array):
	for carta in array:
		print(carta.titulo)
