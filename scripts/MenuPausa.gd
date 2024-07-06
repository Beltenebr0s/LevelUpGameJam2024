extends Panel

@onready var libro_abierto = $LibroAbierto

@onready var slider_musica = $LibroAbierto/PaginaSettings/Settings/VolumenMusica
@onready var slider_SFX = $LibroAbierto/PaginaSettings/Settings/VolumenSFX
@onready var mute_musica = $LibroAbierto/PaginaSettings/Settings/VolumenMusica/MuteMusica
@onready var mute_SFX = $LibroAbierto/PaginaSettings/Settings/VolumenSFX/MuteSFX
@export var lista_sfx_ui_buttons : Array[AudioStreamWAV]
@onready var sfx_audio_player = $SFX

var ui_buttons
var pausado : bool = false

func _ready():
	ui_buttons = get_tree().get_nodes_in_group("ui_button")
	for button in ui_buttons:
		button.mouse_entered.connect(_on_button_mouse_entered)
	slider_musica.value = Global.volumen_musica
	slider_SFX.value = Global.volumen_SFX
	mute_musica.button_pressed = Global.musica_muted
	mute_SFX.button_pressed = Global.SFX_muted
	libro_abierto.visible = true
	mostrar_pagina_inicio()
	
	# pause_mode = 

func _input(event):
	if event.is_action_pressed("Pausa"):
		pausado = !pausado
		get_tree().paused = pausado
		visible = pausado

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
	Global.cambiar_vol_musica(value)

func _on_volumen_sfx_value_changed(value):
	Global.cambiar_vol_SFX(value)

func _on_mute_musica_pressed():
	Global.musica_muted = mute_musica.button_pressed
	Global.cambiar_vol_musica(slider_musica.value)

func _on_mute_sfx_pressed():
	Global.SFX_muted = mute_SFX.button_pressed
	Global.cambiar_vol_SFX(slider_SFX.value)

func _on_home_pressed():
	mostrar_pagina_inicio()

func _on_button_mouse_entered():
	sfx_audio_player.stream = lista_sfx_ui_buttons.pick_random()
	sfx_audio_player.play()
