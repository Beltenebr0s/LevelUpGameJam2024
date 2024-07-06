extends Node

@export var vol_min : float = -20
@export var vol_max : float = 20

var porcentaje_musica : float = 50
var porcentaje_sfx : float = 50
var musica_muted : bool = false
var sfx_muted : bool = false

var ratio : float

@onready var medidor_dia = $SFX/InGame/MedidorDia
@onready var alerta_combo = $SFX/InGame/AlertaCombo
@onready var cartas_pasivas = $SFX/InGame/CartasPasivas
@onready var jugar_carta = $SFX/InGame/JugarCarta
@onready var seleccionar_carta = $SFX/InGame/SeleccionarCarta
@onready var reload = $SFX/InGame/Reload

@onready var boton_select = $SFX/Menus/BotonSelect
@onready var boton_down = $SFX/Menus/BotonDown

func _ready():
	ratio = (abs(vol_max) + abs(vol_min))/100
	pass

var sfx_bus = AudioServer.get_bus_index("SFX")
var music_bus = AudioServer.get_bus_index("Musica")

func change_music_volume(_volumen : float):
	porcentaje_musica = _volumen
	AudioServer.set_bus_volume_db(music_bus, vol_min + porcentaje_musica * ratio)

func change_sfx_volume(_volumen : float):
	porcentaje_sfx = _volumen
	AudioServer.set_bus_volume_db(sfx_bus, vol_min + porcentaje_sfx * ratio)

func mute_music():
	musica_muted = !musica_muted
	AudioServer.set_bus_mute(music_bus, musica_muted)

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

func play_boton_select():
	boton_select.play()

func play_boton_down():
	boton_down.play()
