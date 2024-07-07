extends Panel

@onready var libro_abierto = $LibroAbierto
@onready var pagina_inicio = $LibroAbierto/PaginaInicio
@onready var pagina_settings = $LibroAbierto/PaginaSettings
@onready var pagina_tutorial = $LibroAbierto/PaginaTutorial

var ui_buttons
var pausado : bool = false

func _ready():
	ui_buttons = get_tree().get_nodes_in_group("ui_button")
	for button in ui_buttons:
		button.mouse_entered.connect(_on_button_mouse_entered)
		button.button_down.connect(_on_button_down)
		button.pressed.connect(_on_button_pressed)
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
	pagina_inicio.visible = true
	pagina_tutorial.visible = false
	pagina_settings.visible = false

func _on_settings_pressed():
	print("Ajustes")
	pagina_settings.visible = true
	pagina_tutorial.visible = false
	pagina_inicio.visible = false
	
func _on_explicacion_pressed():
	print("Explicacion")
	pagina_settings.visible = false
	pagina_tutorial.visible = true
	pagina_inicio.visible = false

func _on_exit_pressed():
	get_tree().quit()

func _on_home_pressed():
	mostrar_pagina_inicio()

func _on_button_mouse_entered():
	Audio.play_boton_select()
func _on_button_down():
	Audio.play_boton_down()
func _on_button_pressed():
	Audio.play_pasar_pagina()

func _on_home_focus_entered():
	Audio.play_movimiento_posit()
func _on_home_focus_exited():
	Audio.play_movimiento_posit()
