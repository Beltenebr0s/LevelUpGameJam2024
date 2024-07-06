extends Panel

var SAVE_FILE_DIRECTION = 'user://gamescores.save'
@onready var ranking_text = $LibroAbierto/PaginaFinal/Final/Ranking/RankingTextLabel
@onready var libro_cerrado = $LibroCerrado
@onready var libro_abierto = $LibroAbierto
@onready var tutorial = $LibroAbierto/PaginaTutorial
@onready var slider_musica = $LibroAbierto/PaginaSettings/Settings/VolumenMusica
@onready var slider_SFX = $LibroAbierto/PaginaSettings/Settings/VolumenSFX
@onready var mute_musica = $LibroAbierto/PaginaSettings/Settings/VolumenMusica/MuteMusica
@onready var mute_SFX = $LibroAbierto/PaginaSettings/Settings/VolumenSFX/MuteSFX

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
		$LibroAbierto.visible = !Global.b_first_game
		$LibroAbierto/PaginaInicio.visible = false
		$LibroAbierto/PaginaSettings.visible = false
		$LibroAbierto/PaginaCredits.visible = false
		$LibroAbierto/PaginaFinal.visible = !Global.b_first_game
		$LibroAbierto/PaginaFinal/Final/Score.text = str(Global.puntos_locura)
		if (Global.puntos_locura > 100):
			$LibroAbierto/PaginaFinal/Final/Victoria.visible = true
		else:
			$LibroAbierto/PaginaFinal/Final/Derrota.visible = true
		
		
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
	libro_abierto.visible = true
	libro_cerrado.visible = false


func _on_play_pressed():
	if (Global.b_first_game):
		libro_abierto.visible = true
		libro_cerrado.visible = false
		tutorial.visible = true
		$LibroAbierto/PaginaInicio.visible = false
		$LibroAbierto/PaginaSettings.visible = false
		$LibroAbierto/PaginaCredits.visible = false
	else:
		_on_start_game_pressed()


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

func _on_home_pressed():
	print("Inicio")
	$LibroAbierto.visible = true
	$LibroAbierto/PaginaInicio.visible = true
	$LibroAbierto/PaginaSettings.visible = false
	$LibroAbierto/PaginaCredits.visible = false
	$LibroAbierto/PaginaFinal.visible = false

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
