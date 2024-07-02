extends Node

var selected_card = null
var ai_selected_card = null
var n_max_jugadas = 6
var n_jugada = 0
@onready var mazo_jugador = $Board/MazoCartas
@onready var mazo_ia = $Board/MazoCartasIA
@onready var mano_ui = $cartasUI

func _ready():
	mazo_jugador.carta_seleccionada.connect(seleccionar_carta)
	inicar_juego()
	
# QUITAR ESTO QUE ES SÓLO PARA DEBUG!!!
func _process(delta):
	if Input.is_action_just_pressed("jugar_carta_1"):
		mazo_jugador.mano[0].jugar()
	if Input.is_action_just_pressed("jugar_carta_2"):
		mazo_jugador.mano[1].jugar()
	if Input.is_action_just_pressed("jugar_carta_3"):
		mazo_jugador.mano[2].jugar()

func inicar_juego():
	while (n_jugada < n_max_jugadas):
		await jugar_turno()
		n_jugada = n_jugada+1    
	decidir_final()
		
	
func jugar_turno():
	print("Nuevo turno: ", n_jugada)
	crear_manos()
	mostrar_mano_jugador()
	print("		- espero a la jugada")
	await mazo_jugador.carta_seleccionada
	print("		- jugada realizada")
	jugada_ia()
	aplicar_efecto_turno()
	
func crear_manos():
	mazo_jugador.barajar_cartas(3)
	mazo_ia.barajar_cartas(3)

func seleccionar_carta(carta):
	selected_card = carta
	print("		- Carta seleccionada por el jugador:", selected_card.titulo)

func jugada_ia():
	ai_selected_card = mazo_ia.mano.pick_random()
	print("		* Carta seleccionada por la IA:", ai_selected_card.titulo)

func aplicar_efecto_turno():
	print("		-- Aplicando efecto de las cartas:", selected_card.titulo, " y ", ai_selected_card.titulo)
	var resultado = selected_card.valor - ai_selected_card.valor
	print("			-> Resultado del turno: ", resultado)
	if selected_card.desbloquea_pasiva:
		print("pasiva")

func decidir_final():
	print("Fin del juego")
	
func mostrar_mano_jugador():
	$cartasUI.colocar_cartas_en_mano(mazo_jugador.mano)
