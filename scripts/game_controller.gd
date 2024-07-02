extends Node

var selected_card = null
var ai_selected_card = null
var n_max_jugadas = 6
var n_jugada = 0
@onready var mazo_jugador = $"../MazoCartas"
@onready var mazo_ia = $"../MazoCartasIA"

func _ready():
	inicar_juego()
	mazo_jugador.carta_seleccionada.connect(seleccionar_carta)

func inicar_juego():
	while (n_jugada >= n_max_jugadas):
		jugar_turno()
		n_jugada = n_jugada+1    
	decidir_final()
		
	
func jugar_turno():
	print("Nuevo turno")
	crear_manos()
	await mazo_jugador.carta_seleccionada
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
	
