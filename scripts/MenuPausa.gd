extends Panel

@onready var libro_abierto = $LibroAbierto

@onready var slider_musica = $LibroAbierto/PaginaSettings/Settings/VolumenMusica
@onready var slider_SFX = $LibroAbierto/PaginaSettings/Settings/VolumenSFX
@onready var mute_musica = $LibroAbierto/PaginaSettings/Settings/VolumenMusica/MuteMusica
@onready var mute_SFX = $LibroAbierto/PaginaSettings/Settings/VolumenSFX/MuteSFX

var ui_buttons
var pausado : bool = false

func _ready():
	ui_buttons = get_tree().get_nodes_in_group("ui_button")
	for button in ui_buttons:
		button.mouse_entered.connect(_on_button_mouse_entered)
		button.button_down.connect(_on_button_down)
	
	slider_musica.value = Audio.porcentaje_musica
	slider_SFX.value = Audio.porcentaje_sfx
	mute_musica.button_pressed = Audio.musica_muted
	mute_SFX.button_pressed = Audio.sfx_muted
	
	libro_abierto.visible = true
	mostrar_pagina_inicio()
	
	# pause_mode = 

func _input(event):
	if event.is_action_pressed("Pausa"):
		pausa()

func pausa():
	pausado = !pausado
	get_tree().paused = pausado
	visible = pausado
	mostrar_pagina_inicio()

func mostrar_pagina_inicio():
	print("Home")
	$LibroAbierto/PaginaInicio.visible = true
	$LibroAbierto/PaginaTutorial.visible = false
	$LibroAbierto/PaginaSettings.visible = false

func _on_settings_pressed():
	print("Ajustes")
	$LibroAbierto/PaginaSettings.visible = true
	$LibroAbierto/PaginaTutorial.visible = false
	$LibroAbierto/PaginaInicio.visible = false
	
func _on_explicacion_pressed():
	print("Explicacion")
	$LibroAbierto/PaginaSettings.visible = false
	$LibroAbierto/PaginaTutorial.visible = true
	$LibroAbierto/PaginaInicio.visible = false

func _on_exit_pressed():
	get_tree().quit()

func _on_volumen_musica_value_changed(value):
	Audio.change_music_volume(value)

func _on_volumen_sfx_value_changed(value):
	Audio.change_sfx_volume(value)

func _on_mute_musica_pressed():
	Audio.mute_music()

func _on_mute_sfx_pressed():
	Audio.mute_sfx()

func _on_home_pressed():
	mostrar_pagina_inicio()

func _on_button_mouse_entered():
	Audio.boton_select.play()

func _on_button_down():
	Audio.boton_down.play()
