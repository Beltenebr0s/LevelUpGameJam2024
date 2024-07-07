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
@onready var fade = $Fade
@onready var score_request = $ScoreRequest
@onready var escena_juego = preload("res://escenas/game.tscn")

var lista_cartas = []
@onready var indice_carta = 0
var ui_buttons = []
var botones_pagina = []
var postits = []

func _ready():
	score_request.received_scores.connect(print_score)
	score_request.ranking_error.connect(disable_ranking)
	fade.set_siguiente_escena(Global.escena_game)
	fade.fade_in(!Global.b_first_game)
	ui_buttons = get_tree().get_nodes_in_group("ui_button")
	for button in ui_buttons:
		button.mouse_entered.connect(Audio.play_boton_select)
		button.button_down.connect(Audio.play_boton_down)
		button.pressed.connect(Audio.play_pasar_pagina)
	
	botones_pagina = get_tree().get_nodes_in_group("boton_pagina")
	for boton in botones_pagina:
		boton.pressed.connect(Audio.play_pasar_pagina)
	
	postits = get_tree().get_nodes_in_group("postit")
	for boton in postits:
		boton.focus_entered.connect(Audio.play_pasar_pagina)
		boton.focus_exited.connect(Audio.play_movimiento_posit)
	
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
		Audio.play_abrir_libro()
		$LibroAbierto.visible = !Global.b_first_game
		$LibroAbierto/PaginaInicio.visible = false
		$LibroAbierto/PaginaSettings.visible = false
		$LibroAbierto/PaginaCredits.visible = false
		$LibroAbierto/PaginaFinal.visible = !Global.b_first_game
		$LibroAbierto/PaginaFinal/Final/Score.text = str(Global.puntos_locura)
		if (Global.puntos_locura > 100):
			Audio.play_victoria()
			$LibroAbierto/PaginaFinal/Final/Victoria.visible = true
			$LibroAbierto/PaginaFinal/Final/Derrota.visible = false
		else:
			Audio.play_derrota()
			$LibroAbierto/PaginaFinal/Final/Derrota.visible = true
			$LibroAbierto/PaginaFinal/Final/Victoria.visible = false
		_save_current_score()

func _on_titulo_juego_pressed():
	libro_cerrado.visible = false
	Audio.play_abrir_libro()
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
	Audio.transition_to_game()
	fade.fade_out()

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
	if !$LibroAbierto/PaginaInicio.visible:
		Audio.play_pasar_pagina()
	$LibroAbierto.visible = true
	$LibroAbierto/PaginaInicio.visible = true
	$LibroAbierto/PaginaTutorial.visible = false
	$LibroAbierto/PaginaHistoria.visible = false
	$LibroAbierto/PaginaSettings.visible = false
	$LibroAbierto/PaginaCredits.visible = false
	$LibroAbierto/PaginaFinal.visible = false
	galeria.visible = false
	$LibroAbierto/PaginaInicio/Galeria.visible = !Global.b_first_game

func _on_exit_pressed():
	get_tree().quit()

func _save_current_score():
	score_request.save_score_on_server(Global.puntos_locura)
	
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
	Audio.play_pasar_pagina()

func _on_btn_siguiente_pressed():
	indice_carta = (indice_carta + 1) % lista_cartas.size()
	mostrar_carta()
	Audio.play_pasar_pagina()


func print_score(score):
	$LibroAbierto/PaginaFinal/Final/Ranking.visible = true
	print("PRINT SCORE")
	var ranking_score_list = []
	for player_score in score:
		var score_dict = convert_score_str_to_dict(player_score)
		print(score_dict)
		ranking_score_list.append(score_dict)
	ordenar_y_mostrar_ranking(ranking_score_list)

func ordenar_y_mostrar_ranking(scores):
	var posicion : int = 1
	scores.sort_custom(func(a, b): return a['Score'] > b['Score'])
	for score in scores:
		ranking_text.text += str(posicion)
		ranking_text.text += '. '
		ranking_text.text += str(score['Score'])
		ranking_text.text += ' - - - - - - - '
		ranking_text.text += score['Username']
		ranking_text.text += ' '
		ranking_text.text += str(score['Time'])
		ranking_text.text += '\n'
		posicion+=1;
		if posicion > 8:
			break

func convert_score_str_to_dict(score_str : String):
	var score_split = score_str.split(",") # 0 Username, 1 Score, 2 Time
	var _raw_username
	var raw_score = int(get_score(score_split[1]))
	var raw_time = get_time(score_split[2])
	var save_dict = {
		"Username" : "",
		"Score" : raw_score,
		"Time" : raw_time
	}
	return save_dict
func get_username(_str_user : String) -> String:
	return ""
func get_score(str_score : String) -> String:
	var regex = RegEx.new()
	regex.compile("\\d+")
	var result = regex.search(str_score)
	return result.get_string()
func get_time(str_time : String) -> String:
	var regex = RegEx.new()
	regex.compile("\\d{2}\\/\\d{2}\\/\\d{4} \\d{2}:\\d{2}")
	var result = regex.search(str_time)
	return result.get_string()
	
func disable_ranking():
	$LibroAbierto/PaginaFinal/Final/Ranking.visible = true
	ranking_text.text = "\n"
	ranking_text.text += "  		   MePer d0nas?¡ \n"
	ranking_text.text += " yo habia ponido mi rankin onlin aki :(\n"
	ranking_text.text += "   :C     no encuentro eL interNete\n"
	ranking_text.text += "                                      D: "
