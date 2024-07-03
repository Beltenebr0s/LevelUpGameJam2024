extends Control

var carta_arriba = false
var carta_jugada = false
@onready var animation_player = $AnimationPlayer
@onready var carta = $Carta
@onready var titulo = $Carta/descripcion/titulo
@onready var descripcion = $Carta/descripcion/descripcion

func _ready():
	ocultar_descripción()

func subir_carta():
	animation_player.play("subir_carta")
	actualizar_descripcion()
	
func bajar_carta():
	animation_player.play_backwards("subir_carta")
	
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
	subir_carta()

func _on_boton_carta_mouse_exited():
	bajar_carta()
	
func actualizar_descripcion():
	self.titulo.text = self.carta.titulo
	self.descripcion.text = self.carta.descripcion
	
func ocultar_carta(no_jugada : bool):
	# false para ocultar todas las cartas
	# true para ocultar solo las no jugadas
	if no_jugada and carta_jugada:
		pass
	else:
		descripcion.visible = false

func set_carta(_carta):
	carta_jugada = false
	self.carta = _carta
	actualizar_descripcion()


func _on_boton_carta_pressed():
	carta_jugada = true
	self.carta.jugar()
