extends Node2D
@onready var puntos_locura : float
@onready var b_first_game : bool = true
@onready var cartas_jugadas : Array[String] = []
@onready var auto_skip_ia : bool = false
@onready var graficos_4k : bool = false

@onready var escena_game : PackedScene = preload("res://escenas/game.tscn")
@onready var escena_menu : PackedScene = preload("res://escenas/menu_principal.tscn")

signal graficos_4k_cambio

func graficos_4k_toggle(_value):
	graficos_4k = _value
	graficos_4k_cambio.emit()
