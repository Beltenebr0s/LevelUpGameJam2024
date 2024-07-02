extends Sprite2D

@onready var titulo : String
@onready var descripcion : String
@onready var tipo : int
@onready var reutilizable : bool = false
@onready var desbloquea_pasiva : bool
@onready var requisitos : int
@onready var coste : int
@onready var valor : int

signal jugar_carta(carta)

func jugar():
	jugar_carta.emit(self)
	
