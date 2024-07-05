extends Panel

@onready var libro_cerrado = $LibroCerrado
@onready var libro_abierto = $LibroAbierto
@onready var tutorial = $tutorial

@onready var escena_juego = preload("res://escenas/game.tscn")

func _ready():
	libro_abierto.visible = !Global.b_first_game
	libro_cerrado.visible = Global.b_first_game
	tutorial.visible = false
	if (!Global.b_first_game):
		$LibroAbierto/PaginaDerecha.visible = !Global.b_first_game
		$LibroAbierto/PaginaDerecha/Settings.visible = false
		$LibroAbierto/PaginaDerecha/Credits.visible = false
		$LibroAbierto/PaginaDerecha/Final.visible = !Global.b_first_game
		$LibroAbierto/PaginaDerecha/Final/Score.text = str(Global.puntos_locura)
		if (Global.puntos_locura > 100):
			$LibroAbierto/PaginaDerecha/Final/Victoria.visible = true
		else:
			$LibroAbierto/PaginaDerecha/Final/Derrota.visible = true
		
		
		var node : RichTextLabel = get_node("LibroAbierto/PaginaDerecha/Final/Historia/TextoHistoria")
		for aux in Global.cartas_jugadas:
			node.text += aux
			node.text += '\n'

func _on_titulo_juego_pressed():
	libro_abierto.visible = true
	$LibroAbierto/PaginaDerecha.visible = false
	libro_cerrado.visible = false


func _on_play_pressed():
	if (Global.b_first_game):
		libro_abierto.visible = false
		libro_cerrado.visible = false
		tutorial.visible = true
	else:
		_on_start_game_pressed()


func _on_start_game_pressed():
	get_tree().change_scene_to_packed(escena_juego)

func _on_settings_pressed():
	print("Ajustes")
	$LibroAbierto/PaginaDerecha.visible = true
	$LibroAbierto/PaginaDerecha/Settings.visible = true
	$LibroAbierto/PaginaDerecha/Credits.visible = false
	$LibroAbierto/PaginaDerecha/Final.visible = false

func _on_credits_pressed():
	print("Créditos")
	$LibroAbierto/PaginaDerecha.visible = true
	$LibroAbierto/PaginaDerecha/Settings.visible = false
	$LibroAbierto/PaginaDerecha/Credits.visible = true
	$LibroAbierto/PaginaDerecha/Final.visible = false


func _on_exit_pressed():
	get_tree().quit()
