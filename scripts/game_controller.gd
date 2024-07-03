extends Node

var selected_card = null
var ai_selected_card = null
var ai_selected_card_in_hand = null
var n_max_jugadas = 6
var n_jugada = 0
var mulligan_usado = false
@onready var mazo_jugador = $Board/MazoCartas
@onready var mazo_ia = $Board/MazoCartasIA
@onready var mano_ui = $cartasUI
@onready var mano_iai = $cartasIAI
@onready var medidor_locura = $medidor_locura
@onready var pasivas_ui = $pasivasUI
func _ready():
	pasivas_ui.mulligan.connect(mulligan)
	mazo_jugador.carta_seleccionada.connect(seleccionar_carta)
	inicar_juego()

func _process(delta):
	if Input.is_action_just_pressed("Desbloquear Caballero"):
		pasivas_ui.activar(0)
	if Input.is_action_just_pressed("Desbloquear Vigil"):
		pasivas_ui.activar(1)
	if Input.is_action_just_pressed("Desbloquear Cirujano"):
		pasivas_ui.activar(2)
	if Input.is_action_just_pressed("Desbloquear Sacerdote"):
		pasivas_ui.activar(3)

func inicar_juego():
	pasivas_ui.desactivar(-1)
	while (n_jugada < n_max_jugadas):
		await jugar_turno()
		n_jugada = n_jugada+1    
	decidir_final()
		
	
func jugar_turno():
	print("Nuevo turno: ", n_jugada)
	mulligan_usado = false
	crear_manos()
	print("Mano del jugador:")
	mostrar_mano_jugador()
	print("		- espero a la jugada")
	await mazo_jugador.carta_seleccionada
	mano_ui.ocultar_cartas(true)
	print("		- jugada realizada")
	aplicar_efecto_carta(true)
	await get_tree().create_timer(2.0).timeout
	mano_ui.ocultar_cartas(false)
	await jugada_ia()
	
func crear_manos():
	mazo_jugador.barajar_cartas(5, medidor_locura.value, false)
	mazo_ia.barajar_cartas(5, medidor_locura.value, true)

func seleccionar_carta(carta):
	selected_card = carta
	print("		- Carta seleccionada por el jugador:", selected_card.titulo)

func jugada_ia():
	mostrar_mano_ia()
	await get_tree().create_timer(1.0).timeout
	ai_selected_card_in_hand = mano_iai.cartas.pick_random()
	ai_selected_card = ai_selected_card_in_hand.carta
	print("		* Carta seleccionada por la IA:", ai_selected_card.titulo)
	ai_selected_card_in_hand.seleccionar_carta()
	mano_iai.ocultar_cartas(true)
	aplicar_efecto_carta(false)
	await get_tree().create_timer(2.0).timeout
	mano_iai.ocultar_cartas(false)

func aplicar_efecto_carta(b_is_player : bool):
	var resultado
	print("		-- Aplicando efecto de la carta:" )	
	if(b_is_player):
		resultado = aplicar_pasivas_activas()
		activar_pasiva()
		
	else:
		resultado = nerf_card_to_ia()
	medidor_locura.suma_locos(resultado)
	print("			-> Resultado del turno: ", resultado)

func nerf_card_to_ia():
	return ai_selected_card.valor * 0.8 * -1

func activar_pasiva():
	if selected_card.desbloquea_pasiva:
		print("		-- activando pasiva tipo:", selected_card.tipo)
		pasivas_ui.activar(selected_card.tipo)

func aplicar_pasivas_activas():
	print("		-- Comprobando si está activada la pasiva correspondiente: ", selected_card.tipo)
	var resultado = selected_card.valor
	if pasivas_ui.pasiva_activada(0):
		resultado += 15
	if (selected_card.tipo == 1 or selected_card.tipo == 2) and pasivas_ui.pasiva_activada(selected_card.tipo):
		resultado = roundi(2 * selected_card.valor)
	return resultado

func mulligan():
	if mano_ui.mano_lista and !mulligan_usado:
		mulligan_usado = true
		mano_ui.ocultar_cartas(-1)
		crear_manos()
		await get_tree().create_timer(2.0).timeout
		mostrar_mano_jugador()
	pass

func decidir_final():
	print("Fin del juego")
	n_jugada = 0
	Global.puntos_locura = medidor_locura.value
	Global.b_first_game = false
	get_tree().change_scene_to_file("res://escenas/menu_principal.tscn")
	
func mostrar_mano_jugador():
	mano_ui.colocar_cartas_en_mano(mazo_jugador.mano)

func mostrar_mano_ia():
	mano_iai.colocar_cartas_en_mano(mazo_ia.mano)
