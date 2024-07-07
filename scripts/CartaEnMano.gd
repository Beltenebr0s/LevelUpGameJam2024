extends Control

var carta_jugada = false
var carta_oculta = false
var carta = null

var borde_tipos = ["res://texturas/cartas/Borde_Azul.png", "res://texturas/cartas/Borde_Rojo.png", "res://texturas/cartas/Borde_Verde.png"]
var borde_pasiva = "res://texturas/cartas/Borde_Purpura.png"

@onready var animation_player = $AnimationPlayer 
@onready var titulo = $Carta/popup/titulo
@onready var descripcion = $Carta/popup/descripcion
@onready var popup = $Carta/popup
@onready var textura = $Carta/TexturaCarta
@onready var borde = $Carta/Borde


func _ready():
	carta_oculta = true
	$Carta.position = Vector2(0, 200)
	ocultar_descripcion()

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
			ocultar_descripcion()
			animation_player.play("ocultar_carta_jugada")
	else:
		animation_player.play("ocultar_carta")
		carta_oculta = true
		ocultar_descripcion()

func subir_carta_mas():
	animation_player.play("subir_carta_mas")

func seleccionar_carta():
	carta_jugada = true
	animation_player.play("seleccionar_carta")

func mostrar_descripcion():
	self.popup.visible = true
	
func ocultar_descripcion():
	self.popup.visible = false

func visibilidad_descripcion():
	var es_visible = animation_player.get_playing_speed() > 0
	if es_visible:
		actualizar_descripcion()
		mostrar_descripcion()
	else:
		ocultar_descripcion()

func _on_boton_carta_mouse_entered():
	if !carta_jugada && !carta_oculta:
		Audio.play_seleccionar_carta()
		subir_carta()

func _on_boton_carta_mouse_exited():
	if !carta_jugada && !carta_oculta:
		bajar_carta()

func actualizar_sprite():
	textura.texture = carta.texture

func actualizar_descripcion():
	self.titulo.text = self.carta.titulo
	self.descripcion.text = self.carta.descripcion

func actualizar_borde():
	if carta.funcion == 1:
		self.borde.texture = load(borde_pasiva)
	else:
		self.borde.texture = load("res://texturas/cartas/Borde_Rojo.png")

func set_carta(_carta):
	carta_jugada = false
	self.carta = _carta
	actualizar_sprite()
	actualizar_borde()
	actualizar_descripcion()

func _on_boton_carta_pressed():
	if !carta_jugada && !carta_oculta:
		Audio.play_jugar_carta()
		Audio.play_sonido_tipo(self.carta.tipo, self.carta.desbloquea_pasiva)
		carta_jugada = true
		ocultar_descripcion()
		subir_carta_mas()
		self.carta.jugar()
	elif !carta_oculta && carta_jugada:
		carta_jugada = false
		bajar_carta()
		self.carta.desjugar()
		
