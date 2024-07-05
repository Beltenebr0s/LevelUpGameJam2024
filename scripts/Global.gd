extends Node2D
var puntos_locura : float
var b_first_game : bool = true
var cartas_jugadas: Array[String] = []

var volumen_musica : float = 50
var volumen_SFX : float = 50

signal cambio_volumen_musica
signal cambio_volumen_SFX

func cambiar_vol_musica(_volumen : float):
	volumen_musica = _volumen
	cambio_volumen_musica.emit()

func cambiar_vol_SFX(_volumen : float):
	volumen_SFX = _volumen
	cambio_volumen_SFX.emit()
