extends Node

var selected_card = null
var ai_selected_card = null
var ai_selected_card_in_hand = null
var n_max_jugadas = 6
var n_jugada = 0
var mulligan_usado = false
var menu_pause_instance: Node = null
var scena_menu_pausa
@onready var mazo_jugador = $Board/MazoCartas
@onready var mazo_ia = $Board/MazoCartasIA
@onready var mano_ui = $cartasUI
@onready var mano_iai = $cartasIAI
@onready var medidor_locura = $medidor_locura
@onready var pasivas_ui = $pasivasUI
@onready var reloj = $medidor_dia

@onready var sfx_audio_player = $SFX
@export var lista_sfx_jugar_cartas : Array[AudioStreamWAV]
@export var lista_sfx_repartir_cartas : Array[AudioStreamWAV]
@export var sfx_cambio_turno : AudioStreamWAV

func _ready():
	mano_ui.play_sonido_carta.connect(_on_play_sonido_carta_audio_jugar_carta)
	mano_iai.play_sonido_carta.connect(_on_play_sonido_carta_audio_jugar_carta)
	pasivas_ui.play_sonido_carta.connect(_on_play_sonido_carta_audio_jugar_carta)
	pasivas_ui.mulligan.connect(mulligan)
	mazo_jugador.carta_seleccionada.connect(seleccionar_carta)
	set_process_input(true)
	var root = get_tree().get_root()
	ResourceLoader.load_threaded_request("res://escenas/menu_pausa.tscn")
	var escena_menu_pausa = ResourceLoader.load_threaded_get("res://escenas/menu_pausa.tscn")
	scena_menu_pausa = escena_menu_pausa.instantiate()
	scena_menu_pausa.process_mode = Node.PROCESS_MODE_ALWAYS
	root.add_child(scena_menu_pausa)
	scena_menu_pausa.visible = false
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
		await iniciar_turno()
		await jugar_turno()
		await actualizar_reloj(false)
		await jugada_ia()
		n_jugada = n_jugada+1    
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
	await mazo_jugador.carta_seleccionada
	print("		- jugada realizada")
	aplicar_efecto_carta(true)
	await get_tree().create_timer(2.0).timeout
	mano_ui.ocultar_cartas(false)
	
func crear_manos():
	mazo_jugador.barajar_cartas(5, medidor_locura.value, false)
	mazo_ia.barajar_cartas(5, medidor_locura.value, true)

func seleccionar_carta(carta):
	selected_card = carta
	print("		- Carta seleccionada por el jugador:", selected_card.titulo)
	mano_ui.ocultar_cartas(true)

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
	audio_repartir_mano()
	mano_ui.colocar_cartas_en_mano(mazo_jugador.mano , false)

func mostrar_mano_ia():
	audio_repartir_mano()
	mano_iai.colocar_cartas_en_mano(mazo_ia.mano , true)

func actualizar_reloj(turno_jugador : bool):
	audio_pasar_turno()
	reloj.actualizar_turno(n_jugada + 1)
	if turno_jugador:
		reloj.hacer_de_noche()
	else:
		reloj.hacer_de_dia()
	await reloj.animation_finished

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		scena_menu_pausa.visible = true

func audio_repartir_mano():
	sfx_audio_player.stream = lista_sfx_repartir_cartas.pick_random()
	sfx_audio_player.play()
func audio_jugar_carta():
	sfx_audio_player.stream = lista_sfx_jugar_cartas.pick_random()
	sfx_audio_player.play()
func audio_pasar_turno():
	sfx_audio_player.stream = sfx_cambio_turno
	sfx_audio_player.play()

func _on_play_sonido_carta_audio_jugar_carta():
	audio_jugar_carta()
