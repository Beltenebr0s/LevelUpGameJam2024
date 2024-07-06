extends Node

var selected_cards = null
var n_jugada = 0
var mulligan_usado = false
var menu_pause_instance: Node = null
var scena_menu_pausa

@export var n_max_jugadas = 6
@export var n_cartas_turno_jugador = 2
@export var n_cartas_turno_ia = 2

@onready var mazo_jugador = $Board/MazoCartas
@onready var mazo_ia = $Board/MazoCartasIA
@onready var mano_ui = $cartasUI
@onready var mano_ia = $mano_ia
@onready var medidor_locura = $medidor_locura
@onready var pasivas_ui = $pasivasUI
@onready var reloj = $medidor_dia
@onready var alerta_combo = $alerta_combo

@onready var music_audio_player = $Musica
@onready var sfx_audio_player = $SFX
@export var lista_sfx_jugar_cartas : Array[AudioStreamWAV]
@export var lista_sfx_repartir_cartas : Array[AudioStreamWAV]
@export var sfx_cambio_turno : AudioStreamWAV

func _ready():
	mano_ui.play_sonido_carta.connect(_on_play_sonido_carta_audio_jugar_carta)
	mano_ia.play_sonido_carta.connect(_on_play_sonido_carta_audio_jugar_carta)
	pasivas_ui.play_sonido_carta.connect(_on_play_sonido_carta_audio_jugar_carta)
	Global.cambio_volumen_musica.connect(cambiar_vol_musica)
	Global.cambio_volumen_SFX.connect(cambiar_vol_SFX)
	cambiar_vol_musica()
	cambiar_vol_SFX()
	
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

func _process(delta):
	if Input.is_action_just_pressed("Desbloquear Caballero"):
		pasivas_ui.activar(0)
	if Input.is_action_just_pressed("Desbloquear Vigil"):
		pasivas_ui.activar(1)
	if Input.is_action_just_pressed("Desbloquear Cirujano"):
		pasivas_ui.activar(2)
	if Input.is_action_just_pressed("Desbloquear Sacerdote"):
		pasivas_ui.activar(3)
	if Input.is_action_just_pressed("Triggerear Combo"):
		alerta_combo.mostrar_alerta_combo()

func inicar_juego():
	Global.cartas_jugadas = []
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
	await mazo_jugador.cartas_seleccionadas
	print("		- jugada realizada")
	aplicar_efecto_cartas(true)
	await get_tree().create_timer(2.0).timeout
	mano_ui.ocultar_cartas(false)
	
func crear_manos():
	mazo_jugador.barajar_cartas(5, medidor_locura.locos, false)
	mazo_ia.barajar_cartas(n_cartas_turno_ia, medidor_locura.locos, true)

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
	mano_ia.animar_mano()
	aplicar_efecto_cartas(false)
	await get_tree().create_timer(2.0).timeout
	mano_ia.ocultar_cartas(false)

func aplicar_efecto_cartas(b_is_player : bool):
	var resultado : int
	print("		-- Aplicando efecto de la carta:" )	
	if(b_is_player):
		for carta in selected_cards:
			resultado += aplicar_pasivas_activas(carta)
		for carta in selected_cards:
			activar_pasiva(carta)
		resultado = comprobar_combo(resultado)
	else:
		for carta in mazo_ia.mano:
			resultado += nerf_card_to_ia(carta)
	medidor_locura.suma_locos(resultado)
	print("			-> Resultado del turno: ", resultado)

func nerf_card_to_ia(carta):
	return carta.valor * 0.8 * -1

func activar_pasiva(carta):
	if carta.desbloquea_pasiva:
		print("		-- activando pasiva tipo:", carta.tipo)
		pasivas_ui.activar(carta.tipo)

func aplicar_pasivas_activas(carta):
	print("		-- Comprobando si está activada la pasiva correspondiente: ", carta.tipo)
	var resultado = carta.valor
	if pasivas_ui.pasiva_activada(0):
		resultado += 15
	if (carta.tipo == 1 or carta.tipo == 2) and pasivas_ui.pasiva_activada(carta.tipo):
		resultado = roundi(1.5 * carta.valor)
	return resultado

func comprobar_combo(resultado):
	var hay_multiplicador = false
	for carta in selected_cards:
		hay_multiplicador = hay_multiplicador || (carta.funcion == 2)
	var hay_pasiva = false
	for carta in selected_cards:
		hay_pasiva = hay_pasiva || (carta.funcion == 1)
	var mismo_tipo = true
	for i in range(selected_cards.size() - 1):
		mismo_tipo = mismo_tipo && (selected_cards[i].tipo == selected_cards[i + 1].tipo)
	print(hay_multiplicador, !hay_pasiva, mismo_tipo, resultado)
	if hay_multiplicador && !hay_pasiva && mismo_tipo:
		alerta_combo.mostrar_alerta_combo()
		return resultado * 1.5
	else:
		return resultado

func mulligan():
	if mano_ui.mano_lista and !mulligan_usado:
		mulligan_usado = true
		mano_ui.ocultar_cartas(-1)
		crear_manos()
		await get_tree().create_timer(2.0).timeout
		audio_repartir_mano()
		mano_ui.colocar_cartas_en_mano_mulligan(mazo_jugador.mano)
	pass

func decidir_final():
	print("Fin del juego")
	n_jugada = 0
	Global.puntos_locura = medidor_locura.locos
	Global.b_first_game = false
	get_tree().change_scene_to_file("res://escenas/menu_principal.tscn")
	
func mostrar_mano_jugador():
	audio_repartir_mano()
	mano_ui.colocar_cartas_en_mano(mazo_jugador.mano)

func mostrar_mano_ia():
	audio_repartir_mano()
	mano_ia.colocar_cartas_en_mano(mazo_ia.mano)

func actualizar_reloj(turno_jugador : bool):
	audio_pasar_turno()
	reloj.actualizar_turno(n_jugada + 1)
	if turno_jugador:
		reloj.hacer_de_noche()
	else:
		reloj.hacer_de_dia()
	await reloj.animation_finished

#func _input(event):
#	if event.is_action_pressed("Pausa"):
#		get_tree().paused = true
#		scena_menu_pausa.visible = true

func audio_repartir_mano():
	sfx_audio_player.stream = lista_sfx_repartir_cartas.pick_random()
	sfx_audio_player.play()
func audio_jugar_carta():
	sfx_audio_player.stream = lista_sfx_jugar_cartas.pick_random()
	sfx_audio_player.play()
func audio_pasar_turno():
	await get_tree().create_timer(0.1).timeout
	sfx_audio_player.stream = sfx_cambio_turno
	sfx_audio_player.play()

func _on_play_sonido_carta_audio_jugar_carta():
	audio_jugar_carta()

func cambiar_vol_musica():
	if !Global.musica_muted:
		music_audio_player.volume_db = (Global.volumen_musica - 80)
	else:
		music_audio_player.volume_db = -80

func cambiar_vol_SFX():
	if !Global.SFX_muted:
		sfx_audio_player.volume_db = (Global.volumen_SFX - 80)
	else:
		sfx_audio_player.volume_db = -80
