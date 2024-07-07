extends Control

var huecos_cartas = []
var mano_lista = false

func _ready():
	huecos_cartas = get_children()

func colocar_cartas_en_mano(mano):
	ocultar_cartas(false)
	var n = mano.size()
	for i in range(n):
		huecos_cartas[i].set_carta(mano[i])
	mostrar_cartas()
	mano_lista = true

func colocar_cartas_en_mano_mulligan(mano):
	ocultar_cartas(true)
	var cartas_jugadas = []
	for hueco_carta in huecos_cartas:
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
	for hueco_carta in huecos_cartas:
		if !hueco_carta.carta_jugada:
			hueco_carta.set_carta(mano[i])
			i += 1
	mostrar_cartas()
	mano_lista = true

func mostrar_cartas():
	for hueco_carta in huecos_cartas:
		hueco_carta.mostrar_carta()

func ocultar_cartas(no_jugadas : bool):
	# false para ocultar todas las cartas
	# true para ocultar solo las no jugadas
	mano_lista = false
	for hueco_carta in huecos_cartas:
		hueco_carta.ocultar_carta(no_jugadas)

