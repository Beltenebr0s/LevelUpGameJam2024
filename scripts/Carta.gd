extends Sprite2D

@export var titulo : String
@export var descripcion : String
@export var tipo : int
@export var reutilizable : bool = false
@export var desbloquea_pasiva : bool
@export var requisitos : int
@export var coste : int
@export var valor : int
@onready var carta_usada : bool = false

signal jugar_carta(carta)

func iniciar_carta():
	self.carta_usada = false

func jugar():
	jugar_carta.emit(self)
	
func es_jugable(nivel_locura : int):
	var b_carta_valida = true
	b_carta_valida = b_carta_valida && !self.carta_usada
	b_carta_valida = b_carta_valida && nivel_locura > self.requisitos
	if (self.desbloquea_pasiva):
		b_carta_valida = b_carta_valida && nivel_locura > self.coste
	return b_carta_valida
	
func usar_carta():
	carta_usada = true
	
func devolver_carta():
	carta_usada = false
	
