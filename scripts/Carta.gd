extends Sprite2D
class_name Carta

enum TipoCarta { CABALLERO, VIGIL, CIRUJANO, SACERDOTE }
enum FuncionCarta { NORMAL, PASIVA, MULTIPLICADOR } 

@export var titulo : String
@export_multiline var descripcion : String
@export var tipo : TipoCarta
@export var funcion : FuncionCarta 
@export var reutilizable : bool = false
@export var desbloquea_pasiva : bool
@export var requisitos : int
@export var valor : int
@export var valida_ia: bool = true

@onready var carta_usada : bool = false

signal jugar_carta(carta)

func iniciar_carta():
	self.carta_usada = false

func jugar():
	if !reutilizable:
		self.carta_usada = true
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
