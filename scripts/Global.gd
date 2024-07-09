extends Node2D
var puntos_locura : float
var b_first_game : bool = true
var cartas_jugadas : Array[String] = []
var auto_skip_ia : bool = false
var graficos_4k : bool = false
var mostrar_puntos : bool = false

@onready var escena_game : PackedScene = preload("res://escenas/game.tscn")
@onready var escena_menu : PackedScene = preload("res://escenas/menu_principal.tscn")

signal graficos_4k_cambio
signal mostrar_puntos_cambio

func graficos_4k_toggle(_value):
	graficos_4k = _value
	graficos_4k_cambio.emit()

func mostrar_puntos_toggle(_value):
	mostrar_puntos = _value
	mostrar_puntos_cambio.emit()
