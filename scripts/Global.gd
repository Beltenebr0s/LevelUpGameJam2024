extends Node2D
@onready var puntos_locura : float
@onready var b_first_game : bool = true
@onready var cartas_jugadas : Array[String] = []
@onready var auto_skip_ia : bool = false

@onready var escena_game : PackedScene = preload("res://escenas/game.tscn")
@onready var escena_menu : PackedScene = preload("res://escenas/menu_principal.tscn")
