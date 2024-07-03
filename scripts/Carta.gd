extends Sprite2D
class_name Carta

enum TipoCarta { NORMAL, FUEGO, PESTE }

@export var titulo : String
@export_multiline var descripcion : String
@export var tipo : TipoCarta
@export var reutilizable : bool = false
@export var desbloquea_pasiva : bool
@export var requisitos : int
@export var valor : int
@onready var carta_usada : bool = false
@export var valida_ia: bool = true

signal jugar_carta(carta)

func iniciar_carta():
	self.carta_usada = false

func jugar():
	# self.carta_usada = true # Descomentar esto cuando tengamos cartas de verdad para que no se repitan en el mazo
	jugar_carta.emit(self)
	
func es_jugable(nivel_locura : int, b_ia : bool):
	var b_carta_valida = true
	if ((self.carta_usada)||(b_ia && !valida_ia)||(nivel_locura < self.requisitos)):
		b_carta_valida = false
	if (self.desbloquea_pasiva):
		b_carta_valida = b_carta_valida && nivel_locura > self.valor
	return b_carta_valida
	
func set_carta_usada(valor):
	carta_usada = valor
