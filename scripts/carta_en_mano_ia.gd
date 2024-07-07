extends Node2D

var carta_jugada = false
var carta_oculta = false
@onready var animador = $AnimationPlayer 
@onready var titulo = $Carta/descripcion/titulo
@onready var descripcion = $Carta/descripcion/descripcion
@onready var textura = $Carta/TexturaCarta


func _ready():
	carta_oculta = true
	$Carta.position = Vector2(0, 200)
	ocultar_descripción()

func mostrar_carta():
	carta_oculta = false
	carta_jugada = false
	animador.play_backwards("ocultar_carta")

func ocultar_carta(no_jugada : bool):
	# false para ocultar todas las cartas
	# true para ocultar solo las no jugadas
	if carta_oculta || (carta_jugada && no_jugada):
		pass
	elif carta_jugada:
		carta_oculta = true
		animador.play("ocultar_carta_jugada")
		ocultar_descripción()
	else:
		animador.play("ocultar_carta")
		carta_oculta = true

func seleccionar_carta():
	if Global.auto_skip_ia:
		self.descripcion.visible = false
	else:
		self.descripcion.visible = true
	carta_jugada = true
	animador.play("seleccionar_carta")

func mostrar_descripcion(_titulo : String, _descripcion : String):
	self.titulo.text = _titulo
	self.descripcion.text = _descripcion
	
	self.titulo.visible = true
	#self.descripcion.visible = true
	
func ocultar_descripción():
	self.titulo.visible = false
	#self.descripcion.visible = false

