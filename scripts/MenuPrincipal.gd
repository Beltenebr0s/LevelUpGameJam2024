extends Panel

var SAVE_FILE_DIRECTION = 'user://gamescores.save'
@onready var ranking_text = $LibroAbierto/PaginaFinal/Final/Ranking/RankingTextLabel
@onready var libro_cerrado = $LibroCerrado
@onready var libro_abierto = $LibroAbierto
@onready var historia = $LibroAbierto/PaginaHistoria
@onready var tutorial = $LibroAbierto/PaginaTutorial
@onready var slider_musica = $LibroAbierto/PaginaSettings/Settings/VolumenMusica
@onready var slider_SFX = $LibroAbierto/PaginaSettings/Settings/VolumenSFX
@onready var mute_musica = $LibroAbierto/PaginaSettings/Settings/VolumenMusica/MuteMusica
@onready var mute_SFX = $LibroAbierto/PaginaSettings/Settings/VolumenSFX/MuteSFX
@onready var galeria = $LibroAbierto/PaginaGaleria

@onready var escena_juego = preload("res://escenas/game.tscn")

var lista_cartas = []
@onready var indice_carta = 0
var ui_buttons = []

func _ready():
	ui_buttons = get_tree().get_nodes_in_group("ui_button")
	for button in ui_buttons:
		button.mouse_entered.connect(_on_button_mouse_entered)
		button.button_down.connect(_on_button_down)
		
	lista_cartas = $MazoCartas.get_children()
	
	slider_musica.value = Audio.porcentaje_musica
	slider_SFX.value = Audio.porcentaje_sfx
	mute_musica.button_pressed = Audio.musica_muted
	mute_SFX.button_pressed = Audio.sfx_muted
	
	libro_abierto.visible = !Global.b_first_game
	libro_cerrado.visible = Global.b_first_game
	galeria.visible = false
	tutorial.visible = false
	historia.visible = false
	if (!Global.b_first_game):
		$LibroAbierto.visible = !Global.b_first_game
		$LibroAbierto/PaginaInicio.visible = false
		$LibroAbierto/PaginaSettings.visible = false
		$LibroAbierto/PaginaCredits.visible = false
		$LibroAbierto/PaginaFinal.visible = !Global.b_first_game
		$LibroAbierto/PaginaFinal/Final/Score.text = str(Global.puntos_locura)
		if (Global.puntos_locura > 100):
			$LibroAbierto/PaginaFinal/Final/Victoria.visible = true
			$LibroAbierto/PaginaFinal/Final/Derrota.visible = false
		else:
			$LibroAbierto/PaginaFinal/Final/Derrota.visible = true
			$LibroAbierto/PaginaFinal/Final/Victoria.visible = false
		
		
		#var node : RichTextLabel = get_node("$LibroAbierto/PaginaFinal/Final/Historia/TextoHistoria")
		#for aux in Global.cartas_jugadas:
		#	node.text += aux
		#	node.text += '\n'
		
		_save_current_score()
		var scores = _get_ranking()
		var position : int = 1
		scores.sort_custom(func(a, b): return a['Score'] > b['Score'])
		for score in scores:
			ranking_text.text += str(position)
			ranking_text.text += '. '
			ranking_text.text += str(score['Score'])
			ranking_text.text += ' - - - - - - - - - - - - - - '
			ranking_text.text += score['Username']
			ranking_text.text += ' '
			ranking_text.text += str(score['Time'])
			ranking_text.text += '\n'
			position+=1;

func _on_titulo_juego_pressed():
	libro_cerrado.visible = false
	_on_home_pressed()

func _on_play_pressed():
	if (Global.b_first_game):
		libro_abierto.visible = true
		libro_cerrado.visible = false
		historia.visible = true
		$LibroAbierto/PaginaInicio.visible = false
		$LibroAbierto/PaginaSettings.visible = false
		$LibroAbierto/PaginaCredits.visible = false
	else:
		_on_start_game_pressed()

func _on_tutorial_press():
	if (Global.b_first_game):
		tutorial.visible = true
		historia.visible = false

func _on_start_game_pressed():
	get_tree().change_scene_to_packed(escena_juego)

func _on_settings_pressed():
	print("Ajustes")
	$LibroAbierto.visible = true
	$LibroAbierto/PaginaInicio.visible = false
	$LibroAbierto/PaginaSettings.visible = true
	$LibroAbierto/PaginaCredits.visible = false
	$LibroAbierto/PaginaFinal.visible = false

func _on_credits_pressed():
	print("Créditos")
	$LibroAbierto.visible = true
	$LibroAbierto/PaginaInicio.visible = false
	$LibroAbierto/PaginaSettings.visible = false
	$LibroAbierto/PaginaCredits.visible = true
	$LibroAbierto/PaginaFinal.visible = false
	galeria.visible = false

func _on_home_pressed():
	print("Inicio")
	$LibroAbierto.visible = true
	$LibroAbierto/PaginaInicio.visible = true
	$LibroAbierto/PaginaTutorial.visible = false
	$LibroAbierto/PaginaHistoria.visible = false
	$LibroAbierto/PaginaSettings.visible = false
	$LibroAbierto/PaginaCredits.visible = false
	$LibroAbierto/PaginaFinal.visible = false
	galeria.visible = false

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

func _save_current_score():
	var save_game
	if FileAccess.file_exists(SAVE_FILE_DIRECTION):
		save_game = FileAccess.open(SAVE_FILE_DIRECTION, FileAccess.READ_WRITE)
		save_game.seek_end()
	else:
		save_game = FileAccess.open(SAVE_FILE_DIRECTION, FileAccess.WRITE)
	print(FileAccess.get_open_error())
	var rng = RandomNumberGenerator.new()
	var save_dict = {
		"Username" : "",
		"Score" : Global.puntos_locura,
		"Time" : Time.get_time_string_from_system()
	}
	var json_string = JSON.stringify(save_dict)
	save_game.store_line(json_string)
	save_game.close()
	print(save_dict['Score'])
	
func _get_ranking():
	if not FileAccess.file_exists(SAVE_FILE_DIRECTION):
		print("No saved data")
		return
	var save_game = FileAccess.open(SAVE_FILE_DIRECTION, FileAccess.READ)
	var ranking_scores = []
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var user_score = json.get_data()
		ranking_scores.append(user_score)
	save_game.close()
	return ranking_scores 


func _on_galeria_pressed():
	galeria.visible = true
	$LibroAbierto/PaginaInicio.visible = false
	indice_carta = 0
	mostrar_carta()
	
func mostrar_carta():
	var carta = lista_cartas[indice_carta]
	var titulo_carta = $LibroAbierto/PaginaGaleria/Panel/Titulo
	var desc_carta = $LibroAbierto/PaginaGaleria/Descripcion
	var imagen = $LibroAbierto/PaginaGaleria/Panel/Titulo/MarcoCarta/ImagenCarta
	titulo_carta.text = carta.titulo
	desc_carta.text = carta.descripcion
	imagen.texture = carta.texture

func _on_anterior_pressed():
	if indice_carta > 0:
		indice_carta -= 1
	elif indice_carta == 0:
		indice_carta = lista_cartas.size()-1
	mostrar_carta()

func _on_btn_siguiente_pressed():
	indice_carta = (indice_carta + 1) % lista_cartas.size()
	mostrar_carta()

func _on_button_mouse_entered():
	Audio.boton_select.play()

func _on_button_down():
	Audio.boton_down.play()
