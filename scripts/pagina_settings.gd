extends Panel

@onready var slider_master = $Settings/VolumenMaster
@onready var mute_master = $Settings/VolumenMaster/MuteMaster
@onready var slider_musica = $Settings/VolumenMusica
@onready var mute_musica = $Settings/VolumenMusica/MuteMusica
@onready var slider_SFX = $Settings/VolumenSFX
@onready var mute_SFX = $Settings/VolumenSFX/MuteSFX

func _ready():
	slider_master.value = Audio.porcentaje_master
	mute_master.button_pressed = Audio.master_muted
	slider_musica.value = Audio.porcentaje_musica
	mute_musica.button_pressed = Audio.musica_muted
	slider_SFX.value = Audio.porcentaje_sfx
	mute_SFX.button_pressed = Audio.sfx_muted

func _on_volumen_master_value_changed(value):
	Audio.change_master_volume(value)

func _on_volumen_master_drag_started():
	Audio.play_slide_started()

func _on_volumen_master_drag_ended(value_changed):
	Audio.play_slide_finished()

func _on_mute_master_pressed():
	Audio.mute_master()

func _on_volumen_musica_value_changed(value):
	Audio.change_music_volume(value)

func _on_volumen_musica_drag_started():
	Audio.play_slide_started()

func _on_volumen_musica_drag_ended(value_changed):
	Audio.play_slide_finished()

func _on_mute_musica_pressed():
	Audio.mute_music()

func _on_volumen_sfx_value_changed(value):
	Audio.change_sfx_volume(value)

func _on_volumen_sfx_drag_started():
	Audio.play_slide_started()

func _on_volumen_sfx_drag_ended(value_changed):
	Audio.play_slide_finished()

func _on_mute_sfx_pressed():
	Audio.mute_sfx()
