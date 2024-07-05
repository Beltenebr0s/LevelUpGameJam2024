extends Panel

@onready var libro_cerrado = $LibroCerrado
@onready var libro_abierto = $LibroAbierto
@onready var tutorial = $tutorial
@onready var slider_musica = $LibroAbierto/PaginaDerecha/Settings/VolumenMusica
@onready var slider_SFX = $LibroAbierto/PaginaDerecha/Settings/VolumenSFX
@onready var mute_musica = $LibroAbierto/PaginaDerecha/Settings/VolumenMusica/MuteMusica
@onready var mute_SFX = $LibroAbierto/PaginaDerecha/Settings/VolumenSFX/MuteSFX

@onready var escena_juego = preload("res://escenas/game.tscn")

func _ready():
	slider_musica.value = Global.volumen_musica
	slider_SFX.value = Global.volumen_SFX
	mute_musica.button_pressed = Global.musica_muted
	mute_SFX.button_pressed = Global.SFX_muted
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

func _on_volumen_musica_value_changed(value):
	Global.cambiar_vol_musica(value)

func _on_volumen_sfx_value_changed(value):
	Global.cambiar_vol_SFX(value)

func _on_mute_musica_pressed():
	Global.musica_muted = mute_musica.button_pressed
	Global.cambiar_vol_musica(slider_musica.value)

func _on_mute_sfx_pressed():
	Global.SFX_muted = mute_SFX.button_pressed
	Global.cambiar_vol_SFX(slider_SFX.value)
