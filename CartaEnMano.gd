extends Control

var carta_jugada = false
var carta_oculta = false
@onready var animation_player = $AnimationPlayer
@onready var carta = $Carta
@onready var titulo = $Carta/descripcion/titulo
@onready var descripcion = $Carta/descripcion/descripcion

func _ready():
	carta_oculta = true
	carta.position = Vector2(0, 200)
	ocultar_descripción()

func mano_ia():
	$Carta/BotonCarta.visible = false

func subir_carta():
	animation_player.play("subir_carta")
	actualizar_descripcion()
	
func bajar_carta():
	animation_player.play_backwards("subir_carta")

func mostrar_carta():
	carta_oculta = false
	carta_jugada = false
	animation_player.play_backwards("ocultar_carta")

func ocultar_carta(no_jugada : bool):
	# false para ocultar todas las cartas
	# true para ocultar solo las no jugadas
	if carta_oculta:
		pass
	elif carta_jugada:
		if no_jugada:
			pass
		else:
			carta_oculta = true
			ocultar_descripción()
			animation_player.play("ocultar_carta_jugada")
	else:
		animation_player.play("ocultar_carta")
		carta_oculta = true
		descripcion.visible = false

func subir_carta_mas():
	animation_player.play("subir_carta_mas")

func seleccionar_carta():
	carta_jugada = true
	animation_player.play("seleccionar_carta")

func mostrar_descripcion():
	self.titulo.visible = true
	self.descripcion.visible = true
	
func ocultar_descripción():
	self.titulo.visible = false
	self.descripcion.visible = false

func visibilidad_descripcion():
	var es_visible = animation_player.get_playing_speed() > 0
	if es_visible:
		actualizar_descripcion()
		mostrar_descripcion()
	else:
		ocultar_descripción()

func _on_boton_carta_mouse_entered():
	if !carta_jugada && !carta_oculta:
		subir_carta()

func _on_boton_carta_mouse_exited():
	if !carta_jugada && !carta_oculta:
		bajar_carta()
	
func actualizar_descripcion():
	self.titulo.text = self.carta.titulo
	self.descripcion.text = self.carta.descripcion

func set_carta(_carta):
	carta_jugada = false
	self.carta = _carta
	actualizar_descripcion()

func _on_boton_carta_pressed():
	if !carta_jugada:
		carta_jugada = true
		mostrar_descripcion()
		subir_carta_mas()
		self.carta.jugar()
