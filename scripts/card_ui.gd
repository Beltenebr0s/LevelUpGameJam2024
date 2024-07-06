extends Control

var cartas = []
var mano_lista = false

signal play_sonido_carta

func _ready():
	cartas = get_children()
	for i in cartas:
		i.play_sonido.connect(_on_play_sonido_play_sonido_carta)

func colocar_cartas_en_mano(mano):
	ocultar_cartas(false)
	var n = mano.size()
	for i in range(n):
		cartas[i].set_carta(mano[i])
	mostrar_cartas()
	mano_lista = true

func colocar_cartas_en_mano_mulligan(mano):
	ocultar_cartas(true)
	var cartas_jugadas = []
	for hueco_carta in cartas:
		if hueco_carta.carta_jugada:
			cartas_jugadas.append(hueco_carta.carta)
	print(mano) 
	print(cartas_jugadas)
	var j = 0
	for i in range(mano.size()):
		print(i- j)
		if mano[i - j] in cartas_jugadas:
			mano.pop_at(i- j)
			j += 1
	var i = 0
	for hueco_carta in cartas:
		if !hueco_carta.carta_jugada:
			hueco_carta.set_carta(mano[i])
			hueco_carta.mostrar_carta()
			i += 1
	mano_lista = true

func mostrar_cartas():
	for i in cartas:
		i.mostrar_carta()

func ocultar_cartas(no_jugadas : bool):
	# false para ocultar todas las cartas
	# true para ocultar solo las no jugadas
	mano_lista = false
	for carta in cartas:
		carta.ocultar_carta(no_jugadas)

func _on_play_sonido_play_sonido_carta():
	play_sonido_carta.emit()
