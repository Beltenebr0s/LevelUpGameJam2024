extends Node

@export var vol_min : float = -20
@export var vol_max : float = 10

var porcentaje_master : float = 66
var porcentaje_musica : float = 44
var porcentaje_sfx : float = 44
var master_muted : bool = false
var musica_muted : bool = false
var sfx_muted : bool = false

var ratio : float

@onready var musica_menu_principal = $Musica/MusicaMenuPrincipal
@onready var musica_juego = $Musica/MusicaJuego
@onready var jingle_victoria = $Musica/JingleVictoria
@onready var jingle_derrota = $Musica/JingleDerrota

@onready var sonido_ambiente = $SFX/InGame/SonidoAmbiente
@onready var medidor_dia = $SFX/InGame/MedidorDia
@onready var alerta_combo = $SFX/InGame/AlertaCombo

@onready var medidor_sube = $SFX/InGame/Medidor/MedidorSube
@onready var medidor_baja = $SFX/InGame/Medidor/MedidorBaja
@onready var medidor_loco = $SFX/InGame/Medidor/MedidorLoco
@onready var medidor_normal = $SFX/InGame/Medidor/MedidorNormal

@onready var cartas_pasivas = $SFX/InGame/Cartas/CartasPasivas
@onready var jugar_carta = $SFX/InGame/Cartas/JugarCarta
@onready var seleccionar_carta = $SFX/InGame/Cartas/SeleccionarCarta
@onready var reload = $SFX/InGame/Cartas/Reload

@onready var tipo_normal = $SFX/InGame/TipoDeCartas/TipoNormal
@onready var tipo_fuego = $SFX/InGame/TipoDeCartas/TipoFuego
@onready var tipo_peste = $SFX/InGame/TipoDeCartas/TipoPeste
@onready var tipo_pasiva = $SFX/InGame/TipoDeCartas/TipoPasiva	

@onready var boton_down = $SFX/Menus/BotonDown
@onready var boton_select = $SFX/Menus/BotonSelect
@onready var slide_started = $SFX/Menus/SlideStarted
@onready var slide_finished = $SFX/Menus/SlideFinished
@onready var movimiento_posit = $SFX/Menus/MovimientoPosit
@onready var pasar_pagina = $SFX/Menus/PasarPagina
@onready var abrir_libro = $SFX/Menus/AbrirLibro
@onready var ojo_cerrar = $SFX/Menus/OjoCerrar
@onready var ojo_abrir = $SFX/Menus/OjoAbrir

var master_bus = AudioServer.get_bus_index("Master")
var music_bus = AudioServer.get_bus_index("Musica")
var sfx_bus = AudioServer.get_bus_index("SFX")

var lista_sonidos_tipos = []
var tween : Tween

func _ready():
	lista_sonidos_tipos = [tipo_normal, tipo_fuego, tipo_peste, tipo_pasiva]
	ratio = (abs(vol_max) + abs(vol_min))/100
	
	change_master_volume(porcentaje_master)
	change_music_volume(porcentaje_musica)
	change_sfx_volume(porcentaje_sfx)
	pass

func change_master_volume(_volumen : float):
	porcentaje_master = _volumen
	AudioServer.set_bus_volume_db(master_bus, vol_min + porcentaje_master * ratio)
func mute_master(_toggled_on : bool):
	master_muted = _toggled_on
	AudioServer.set_bus_mute(master_bus, master_muted)

func change_music_volume(_volumen : float):
	porcentaje_musica = _volumen
	AudioServer.set_bus_volume_db(music_bus, vol_min + porcentaje_musica * ratio)
func mute_music(_toggled_on : bool):
	musica_muted = _toggled_on
	AudioServer.set_bus_mute(music_bus, musica_muted)

func change_sfx_volume(_volumen : float):
	porcentaje_sfx = _volumen
	AudioServer.set_bus_volume_db(sfx_bus, vol_min + porcentaje_sfx * ratio)
func mute_sfx(_toggled_on : bool):
	sfx_muted = _toggled_on
	AudioServer.set_bus_mute(sfx_bus, sfx_muted)

func fade_in(_player, _time):
	_player.volume_db = -40
	_player.play()
	tween = get_tree().create_tween()
	await tween.tween_property(_player, "volume_db", 0, _time).finished
	_player.volume_db = 0

func fade_out(_player, _time):
	_player.volume_db = 0
	tween = get_tree().create_tween()
	await tween.tween_property(_player, "volume_db", -40, _time).finished
	_player.stop()
	_player.volume_db = 0

func start_music():
	fade_in(musica_menu_principal, 4)
func transition_to_game():
	await fade_out(musica_menu_principal, 1.5)
	fade_in(sonido_ambiente, 1.5)
	fade_in(musica_juego, 1.5)
func transition_to_menu():
	fade_out(sonido_ambiente, 1.5)
	fade_out(musica_juego, 1.5)

func play_victoria():
	jingle_victoria.play()
	await jingle_victoria.finished
	if !musica_juego.playing:
		musica_menu_principal.play()
func play_derrota():
	jingle_derrota.play()
	await jingle_derrota.finished
	if !musica_juego.playing:
		musica_menu_principal.play()

func play_medidor_dia():
	await get_tree().create_timer(0.1).timeout
	medidor_dia.play()
func play_alerta_combo():
	alerta_combo.play()

func play_medidor_cambio(_value):
	if _value < 0:
		medidor_baja.play()
	else:
		medidor_sube.play()
func play_medidor_estado_cambio(_loco : bool):
	if _loco:
		medidor_loco.play()
	else:
		medidor_normal.play()

func play_cartas_pasivas():
	cartas_pasivas.play()
func play_jugar_carta():
	jugar_carta.play()
func play_seleccionar_carta():
	seleccionar_carta.play()
func play_reload():
	reload.play()

func play_sonido_tipo(_tipo : int, _pasiva : bool):
	if _pasiva:
		lista_sonidos_tipos[3].play()
	else:
		lista_sonidos_tipos[_tipo].play()

func play_toggle_eye(_is_on : bool):
	if _is_on:
		ojo_cerrar.play()
	else:
		ojo_abrir.play()

func play_boton_select():
	boton_select.play()
func play_boton_down():
	boton_down.play()
func play_slide_started():
	slide_started.play()
func play_slide_finished():
	slide_finished.play()
func play_movimiento_posit():
	movimiento_posit.play()
func play_pasar_pagina():
	pasar_pagina.play()
func play_abrir_libro():
	abrir_libro.play()
