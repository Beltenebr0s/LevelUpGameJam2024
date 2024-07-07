extends Panel

@onready var slider_master = $Settings/VolumenMaster
@onready var mute_master = $Settings/VolumenMaster/MuteMaster
@onready var slider_musica = $Settings/VolumenMusica
@onready var mute_musica = $Settings/VolumenMusica/MuteMusica
@onready var slider_SFX = $Settings/VolumenSFX
@onready var mute_SFX = $Settings/VolumenSFX/MuteSFX
@onready var auto_play = $Settings/SkipIa
@onready var graficos_4k = $Settings/Graficos4K



func _ready():
	slider_master.value = Audio.porcentaje_master
	mute_master.button_pressed = Audio.master_muted
	slider_musica.value = Audio.porcentaje_musica
	mute_musica.button_pressed = Audio.musica_muted
	slider_SFX.value = Audio.porcentaje_sfx
	mute_SFX.button_pressed = Audio.sfx_muted
	auto_play.button_pressed = Global.auto_skip_ia
	graficos_4k.button_pressed = Global.graficos_4k
	
	for button in [mute_master, mute_musica, mute_SFX, auto_play, graficos_4k]:
		button.toggled.connect(Audio.play_toggle_eye)

func _on_volumen_master_value_changed(value):
	Audio.change_master_volume(value)

func _on_volumen_master_drag_started():
	Audio.play_slide_started()

func _on_volumen_master_drag_ended(_value_changed):
	Audio.play_slide_finished()

func _on_mute_master_toggled(toggled_on):
	Audio.mute_master(toggled_on)

func _on_volumen_musica_value_changed(value):
	Audio.change_music_volume(value)

func _on_volumen_musica_drag_started():
	Audio.play_slide_started()

func _on_volumen_musica_drag_ended(_value_changed):
	Audio.play_slide_finished()

func _on_mute_musica_toggled(toggled_on):
	Audio.mute_music(toggled_on)

func _on_volumen_sfx_value_changed(value):
	Audio.change_sfx_volume(value)

func _on_volumen_sfx_drag_started():
	Audio.play_slide_started()

func _on_volumen_sfx_drag_ended(_value_changed):
	Audio.play_slide_finished()

func _on_mute_sfx_toggled(toggled_on):
	Audio.mute_sfx(toggled_on)

func _on_skip_ia_toggled(toggled_on):
	Global.auto_skip_ia = toggled_on

func _on_graficos_4k_toggled(toggled_on):
	Global.graficos_4k_toggle(toggled_on)
