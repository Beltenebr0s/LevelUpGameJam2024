extends Panel

@onready var libro_abierto = $LibroAbierto

@onready var slider_musica = $LibroAbierto/PaginaSettings/Settings/VolumenMusica
@onready var slider_SFX = $LibroAbierto/PaginaSettings/Settings/VolumenSFX
@onready var mute_musica = $LibroAbierto/PaginaSettings/Settings/VolumenMusica/MuteMusica
@onready var mute_SFX = $LibroAbierto/PaginaSettings/Settings/VolumenSFX/MuteSFX

func _ready():
	slider_musica.value = Global.volumen_musica
	slider_SFX.value = Global.volumen_SFX
	mute_musica.button_pressed = Global.musica_muted
	mute_SFX.button_pressed = Global.SFX_muted
	libro_abierto.visible = true
	$LibroAbierto/PaginaInicio.visible = true
	$LibroAbierto/PaginaSettings.visible = false
	
	# pause_mode = 

func _on_continue_pressed():
	hide()
	get_tree().paused = false

func _on_settings_pressed():
	print("Ajustes")
	$LibroAbierto/PaginaSettings.visible = true
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
