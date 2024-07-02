extends Control

@onready var cartas = []

func _ready():
	cartas = get_children()

func colocar_cartas_en_mano(mano):
	var n = mano.size()
	for i in range(n):
		cartas[i].set_carta(mano[i])
