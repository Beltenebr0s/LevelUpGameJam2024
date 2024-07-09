extends Node

signal skip_IA_turn_signal

var selected_cards = null
var n_jugada = 0
var mulligan_usado = false
var menu_pause_instance: Node = null
var scena_menu_pausa

var carta_combo = null

@export var n_max_jugadas = 6
@export var n_cartas_turno_jugador = 2
@export var n_cartas_turno_ia = 2

@onready var mazo_jugador = $MazoCartas
@onready var mazo_ia = $MazoCartasIA
@onready var mano_ui = $cartasUI
@onready var mano_ia = $mano_ia
@onready var medidor_locura = $medidor_locura
@onready var pasivas_ui = $pasivasUI
@onready var reloj = $medidor_dia
@onready var alerta_combo = $alerta_combo
@onready var fade = $Fade

func _ready():
	fade.set_siguiente_escena(Global.escena_menu)
	fade.fade_in(true)
	pasivas_ui.mulligan.connect(mulligan)
	mazo_jugador.cartas_seleccionadas.connect(seleccionar_cartas)
	
	set_process_input(true)
	var root = get_tree().get_root()
	ResourceLoader.load_threaded_request("res://escenas/menu_pausa.tscn")
	var escena_menu_pausa = ResourceLoader.load_threaded_get("res://escenas/menu_pausa.tscn")
	scena_menu_pausa = escena_menu_pausa.instantiate()
	scena_menu_pausa.process_mode = Node.PROCESS_MODE_ALWAYS
	root.add_child.call_deferred(scena_menu_pausa)
	scena_menu_pausa.visible = false
	
	mazo_jugador.n_cartas_turno = n_cartas_turno_jugador
	
	inicar_juego()

func _input(event):
	if event.is_action_pressed("skip_IA_turn"):
		emit_signal("skip_IA_turn_signal")

func inicar_juego():
	Global.cartas_jugadas.clear()
	pasivas_ui.desactivar(-1)
	while (n_jugada < n_max_jugadas):
		await iniciar_turno()
		await jugar_turno()
		await actualizar_reloj(false)
		await jugada_ia()
		n_jugada = n_jugada+1    
	await skip_IA_turn_signal
	decidir_final()

func iniciar_turno():
	mulligan_usado = false
	await actualizar_reloj(true)
	print("Nuevo turno: ", n_jugada)
	crear_manos()

func jugar_turno():
	print("Mano del jugador:")
	mostrar_mano_jugador()
	print("		- espero a la jugada")
	await mazo_jugador.cartas_seleccionadas
	print("		- jugada realizada")
	aplicar_efecto_cartas(true)
	await get_tree().create_timer(2.0).timeout
	mano_ui.ocultar_cartas(false)
	
func crear_manos():
	mazo_jugador.barajar_cartas(5, medidor_locura.locos)
	mazo_ia.barajar_cartas(n_cartas_turno_ia, medidor_locura.locos)

func seleccionar_cartas(cartas_a_jugar):
	selected_cards = cartas_a_jugar
	print("		- Cartas seleccionadas por el jugador:")
	for carta in  cartas_a_jugar:
		print(carta.titulo)
		Global.cartas_jugadas.append(carta.titulo)
	mano_ui.ocultar_cartas(true)

func jugada_ia():
	mostrar_mano_ia()
	await get_tree().create_timer(1.0).timeout
	for carta in mano_ia.mano:
		print("		* Carta seleccionada por la IA:", carta.titulo)
	aplicar_counter()
	mano_ia.animar_mano()
	aplicar_efecto_cartas(false)
	if !Global.auto_skip_ia:
		await skip_IA_turn_signal
	else:
		await get_tree().create_timer(1.0).timeout
	mano_ia.ocultar_cartas(false)
	
func aplicar_counter():
	if randf() <= mano_ia.prob_counter:
		print("counter")
		selected_cards.shuffle()
		for carta in selected_cards: 
			if !carta.desbloquea_pasiva && carta.can_counter:
				mano_ia.mano[mano_ia.mano.size() - 1].descripcion = carta.counter
				mano_ia.mano[mano_ia.mano.size() - 1].valor = carta.valor
				if carta_combo != null:
					if carta == carta_combo:
						mano_ia.mano[mano_ia.mano.size() - 1].valor = carta.valor * 1.5
					else:
						mano_ia.mano[mano_ia.mano.size() - 1].valor = carta.valor + carta_combo.valor * 0.5
				if (carta.tipo == 1 or carta.tipo == 2) and pasivas_ui.pasiva_activada(carta.tipo):
					mano_ia.mano[mano_ia.mano.size() - 1].valor += mano_ia.mano[mano_ia.mano.size() - 1].valor*0.5
				mano_ia.mano.remove_at(0)
				break
		if mano_ia.mano.size() > n_cartas_turno_ia:
			mano_ia.mano.remove_at(mano_ia.mano.size() - 1)
	else:
		mano_ia.mano.remove_at(mano_ia.mano.size() - 1)
	carta_combo = null

func aplicar_efecto_cartas(b_is_player : bool):
	var resultado = 0
	print("		-- Aplicando efecto de la carta:" )	
	if(b_is_player):
		for carta in selected_cards:
			resultado += aplicar_pasivas_activas(carta)
		for carta in selected_cards:
			activar_pasiva(carta)
		resultado += comprobar_combo(resultado)
	else:
		for carta in mazo_ia.mano:
			if carta.name == 'Counter':
				resultado += carta.valor * -1
			else:
				resultado += carta.valor * -1
	medidor_locura.suma_locos(resultado)
	print("			-> Resultado del turno: ", resultado)

func activar_pasiva(carta):
	if carta.desbloquea_pasiva:
		print("		-- activando pasiva tipo:", carta.tipo)
		pasivas_ui.activar(carta.tipo)

func aplicar_pasivas_activas(carta):
	print("		-- Comprobando si está activada la pasiva correspondiente: ", carta.tipo)
	var resultado = carta.valor
	if pasivas_ui.pasiva_activada(0):
		resultado += 15
	if carta.tipo != 0 and pasivas_ui.pasiva_activada(carta.tipo):
		resultado = roundi(1.5 * carta.valor)
	return resultado

func comprobar_combo(resultado):
	var hay_multiplicador = false
	for carta in selected_cards:
		hay_multiplicador = hay_multiplicador || (carta.funcion == 2)
		if (carta.funcion != 2):
			carta_combo = carta
	var hay_pasiva = false
	for carta in selected_cards:
		hay_pasiva = hay_pasiva || (carta.funcion == 1)
	var mismo_tipo = true
	for i in range(selected_cards.size() - 1):
		mismo_tipo = mismo_tipo && (selected_cards[i].tipo == selected_cards[i + 1].tipo)
	print(hay_multiplicador, !hay_pasiva, mismo_tipo, resultado)
	if  hay_multiplicador && !hay_pasiva && mismo_tipo:
		alerta_combo.mostrar_alerta_combo()
		Audio.play_alerta_combo()
		Audio.play_sonido_tipo(carta_combo.tipo, false)
		if carta_combo.tipo == 3:
			return carta_combo.valor * 5
		else:
			return carta_combo.valor * 1
	else:
		carta_combo = null
		return 0

func mulligan():
	if mano_ui.mano_lista and !mulligan_usado:
		mulligan_usado = true
		mano_ui.ocultar_cartas(-1)
		crear_manos()
		await get_tree().create_timer(2.0).timeout
		Audio.play_reload()
		mano_ui.colocar_cartas_en_mano_mulligan(mazo_jugador.mano)
	pass

func decidir_final():
	print("Fin del juego")
	n_jugada = 0
	Global.puntos_locura = medidor_locura.locos
	Global.b_first_game = false
	Audio.transition_to_menu()
	fade.fade_out()
	
func mostrar_mano_jugador():
	Audio.play_reload()
	mano_ui.colocar_cartas_en_mano(mazo_jugador.mano)

func mostrar_mano_ia():
	Audio.play_reload()
	mano_ia.colocar_cartas_en_mano(mazo_ia.mano)

func actualizar_reloj(turno_jugador : bool):
	Audio.play_medidor_dia()
	reloj.actualizar_turno(n_jugada + 1)
	if turno_jugador:
		reloj.hacer_de_noche()
	else:
		reloj.hacer_de_dia()
	await reloj.animation_finished
