extends Panel

@onready var libro_abierto = $LibroAbierto

@onready var slider_musica = $LibroAbierto/PaginaDerecha/Settings/VolumenMusica
@onready var slider_SFX = $LibroAbierto/PaginaDerecha/Settings/VolumenSFX

func _ready():
	slider_musica.value = Global.volumen_musica
	slider_SFX.value = Global.volumen_SFX
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
	


func _on_volumen_musica_value_changed(value):
	# await get_tree().create_timer(0.3).timeout
	Global.cambiar_vol_musica(value)
	pass # Replace with function body.


func _on_volumen_sfx_value_changed(value):
	Global.cambiar_vol_SFX(value)
	pass # Replace with function body.
