extends Node

var selected_card = null
var ai_selected_card = null
var n_max_jugadas = 6
var n_jugada = 0
@onready var mazo_jugador = $Board/MazoCartas
@onready var mazo_ia = $Board/MazoCartasIA

func _ready():
	mazo_jugador.carta_seleccionada.connect(seleccionar_carta)
	inicar_juego()

func inicar_juego():
	while (n_jugada < n_max_jugadas):
		await jugar_turno()
		n_jugada = n_jugada+1    
	decidir_final()
		
	
func jugar_turno():
	print("Nuevo turno: ", n_jugada)
	crear_manos()
	print("espero a la jugada")
	await mazo_jugador.carta_seleccionada
	print("jugada realizada")
	jugada_ia()
	aplicar_efecto_turno()
	
func crear_manos():
	mazo_jugador.barajar_cartas(3)
	mazo_ia.barajar_cartas(3)

func seleccionar_carta(carta):
	selected_card = carta
	print("Carta seleccionada por el jugador:", selected_card)

func jugada_ia():
	ai_selected_card = mazo_ia.mano.pickrandom()
	print("Carta seleccionada por la IA:", ai_selected_card)

func aplicar_efecto_turno():
	print("Aplicando efecto de las cartas:", selected_card, "y", ai_selected_card)

func decidir_final():
	print("Fin del juego")
	
