extends TextureProgressBar

@onready var locos = 10
@onready var texto_contador = $TextEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	self.value = 1
	actualizar_medidor()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func suma_locos(locos_nuevos : int):
	locos += locos_nuevos
	if self.value > 100 and locos < 100:
		locos = 101
	elif locos < 1:
		locos = 1
	actualizar_medidor()

func actualizar_medidor():
	while locos != self.value:
		self.value += sign(locos - self.value)
		texto_contador.text = str(self.value)
		await get_tree().create_timer(0.03).timeout
	
