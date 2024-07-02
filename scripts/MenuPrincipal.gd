extends Panel

@onready var libro_cerrado = $LibroCerrado
@onready var libro_abierto = $LibroAbierto

@onready var escena_juego = preload("res://escenas/game.tscn")

func _ready():
	libro_abierto.visible = false
	libro_cerrado.visible = true

func _on_titulo_juego_pressed():
	libro_abierto.visible = true
	$LibroAbierto/PaginaDerecha.visible = false
	libro_cerrado.visible = false


func _on_play_pressed():
	get_tree().change_scene_to_packed(escena_juego)
	


func _on_settings_pressed():
	print("Ajustes")
	$LibroAbierto/PaginaDerecha.visible = true
	$LibroAbierto/PaginaDerecha/Settings.visible = true
	$LibroAbierto/PaginaDerecha/Credits.visible = false

func _on_credits_pressed():
	print("Créditos")
	$LibroAbierto/PaginaDerecha.visible = true
	$LibroAbierto/PaginaDerecha/Settings.visible = false
	$LibroAbierto/PaginaDerecha/Credits.visible = true


func _on_exit_pressed():
	get_tree().quit()
