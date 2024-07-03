extends Node

var selected_card = null
var ai_selected_card = null
var n_max_jugadas = 6
var n_jugada = 0
var mulligan_usado = false
@onready var mazo_jugador = $Board/MazoCartas
@onready var mazo_ia = $Board/MazoCartasIA
@onready var mano_ui = $cartasUI
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
	mazo_jugador.debug_print_valor_medio(mazo_jugador.mano)
	mostrar_mano_jugador()
	print("		- espero a la jugada")
	await mazo_jugador.carta_seleccionada
	mano_ui.ocultar_cartas(true)
	print("		- jugada realizada")
	jugada_ia()
	aplicar_efecto_turno()
	await get_tree().create_timer(1.0).timeout
	
func crear_manos():
	mazo_jugador.barajar_cartas(5, medidor_locura.value, false)
	mazo_ia.barajar_cartas(3, medidor_locura.value, true)

func seleccionar_carta(carta):
	selected_card = carta
	print("		- Carta seleccionada por el jugador:", selected_card.titulo)

func jugada_ia():
	ai_selected_card = mazo_ia.mano.pick_random()
	print("		* Carta seleccionada por la IA:", ai_selected_card.titulo)

func aplicar_efecto_turno():
	# 1. Mirar los efectos que aplican (modificadores de pasivas, etc)
	# 2. Mirar si la carta elegida es una pasiva
		# 2.1.(true) Actualizar UI de habilidades pasivas
	# 3. Aplicar efectos normales
	var valor_carta = selected_card.valor
	print("		-- Comprobando si está activada la pasiva correspondiente: ", selected_card.tipo)
	if pasivas_ui.pasiva_activada(0):
		valor_carta += 15
		print("		-- El Caballero está activado, la carta ahora vale ", valor_carta)
	if (selected_card.tipo == 1 or selected_card.tipo == 2) and pasivas_ui.pasiva_activada(selected_card.tipo):
		valor_carta = roundi(2 * valor_carta)
		print("		-- La pasiva ", selected_card.tipo, " está activada. La carta ahora vale ", valor_carta)
	print("		-- Aplicando efecto de las cartas:", selected_card.titulo, " y ", ai_selected_card.titulo)
	var resultado = valor_carta - ai_selected_card.valor * 0.8
	print("			-> Resultado del turno: ", resultado)
	medidor_locura.suma_locos(resultado)
	if selected_card.desbloquea_pasiva:
		print("		-- activando pasiva tipo:", selected_card.tipo)
		pasivas_ui.activar(selected_card.tipo)

func mulligan():
	if mano_ui.mano_lista and !mulligan_usado:
		mulligan_usado = true
		mano_ui.ocultar_cartas(-1)
		crear_manos()
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
