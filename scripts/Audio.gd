extends Node

@export var vol_min : float = -20
@export var vol_max : float = 10

var porcentaje_master : float = 66
var porcentaje_musica : float = 66
var porcentaje_sfx : float = 66
var master_muted : bool = false
var musica_muted : bool = false
var sfx_muted : bool = false

var ratio : float

@onready var medidor_dia = $SFX/InGame/MedidorDia
@onready var alerta_combo = $SFX/InGame/AlertaCombo
@onready var cartas_pasivas = $SFX/InGame/CartasPasivas
@onready var jugar_carta = $SFX/InGame/JugarCarta
@onready var seleccionar_carta = $SFX/InGame/SeleccionarCarta
@onready var reload = $SFX/InGame/Reload
@onready var medidor_sube = $SFX/InGame/MedidorSube
@onready var medidor_baja = $SFX/InGame/MedidorBaja
@onready var medidor_loco = $SFX/InGame/MedidorLoco
@onready var medidor_normal = $SFX/InGame/MedidorNormal

@onready var boton_down = $SFX/Menus/BotonDown
@onready var boton_select = $SFX/Menus/BotonSelect
@onready var slide_started = $SFX/Menus/SlideStarted
@onready var slide_finished = $SFX/Menus/SlideFinished
@onready var pasar_pagina = $SFX/Menus/PasarPagina
@onready var abrir_libro = $SFX/Menus/AbrirLibro

func _ready():
	ratio = (abs(vol_max) + abs(vol_min))/100
	pass

var master_bus = AudioServer.get_bus_index("Master")
var music_bus = AudioServer.get_bus_index("Musica")
var sfx_bus = AudioServer.get_bus_index("SFX")

func change_master_volume(_volumen : float):
	porcentaje_master = _volumen
	AudioServer.set_bus_volume_db(master_bus, vol_min + porcentaje_master * ratio)

func mute_master():
	master_muted = !master_muted
	AudioServer.set_bus_mute(master_bus, master_muted)

func change_music_volume(_volumen : float):
	porcentaje_musica = _volumen
	AudioServer.set_bus_volume_db(music_bus, vol_min + porcentaje_musica * ratio)

func mute_music():
	musica_muted = !musica_muted
	AudioServer.set_bus_mute(music_bus, musica_muted)

func change_sfx_volume(_volumen : float):
	porcentaje_sfx = _volumen
	AudioServer.set_bus_volume_db(sfx_bus, vol_min + porcentaje_sfx * ratio)

func mute_sfx():
	sfx_muted = !sfx_muted
	AudioServer.set_bus_mute(sfx_bus, sfx_muted)

func play_medidor_dia():
	await get_tree().create_timer(0.1).timeout
	medidor_dia.play()

func play_alerta_combo():
	alerta_combo.play()

func play_cartas_pasivas():
	cartas_pasivas.play()

func play_jugar_carta():
	jugar_carta.play()

func play_seleccionar_carta():
	seleccionar_carta.play()

func play_reload():
	reload.play()

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

func play_boton_select():
	boton_select.play()

func play_boton_down():
	boton_down.play()

func play_slide_started():
	slide_started.play()

func play_slide_finished():
	slide_finished.play()
