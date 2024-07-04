extends Panel

@onready var libro_abierto = $LibroAbierto
@onready var tutorial = $tutorial

@onready var escena_juego = preload("res://escenas/game.tscn")

func _ready():
	libro_abierto.visible = true
	
	# pause_mode = 

func _on_titulo_juego_pressed():
	libro_abierto.visible = true
	$LibroAbierto/PaginaDerecha.visible = false


func _on_continue_pressed():
	hide()
	get_tree().paused = false

func _on_settings_pressed():
	print("Ajustes")
	$LibroAbierto/PaginaDerecha.visible = true
	$LibroAbierto/PaginaDerecha/Settings.visible = true
	$LibroAbierto/PaginaDerecha/Credits.visible = false
	$LibroAbierto/PaginaDerecha/Final.visible = false

func _on_exit_pressed():
	get_tree().quit()
	
