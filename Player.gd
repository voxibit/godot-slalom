extends MeshInstance

const AMPLITUDE :float = 0.05
const PERIOD :float = 2.0

var t:float

onready var camera :Camera = $Camera
var camera_pos0 :Vector3


func _ready():
	camera_pos0 = camera.get_translation()

func _physics_process(delta):
	t += delta
	while t>PERIOD: t-=PERIOD
	var offset :Vector3 = Vector3(0, 0.1+AMPLITUDE*sin(2*PI*t/PERIOD)/2.0, 0)
	set_translation(offset)
	camera.set_translation(camera_pos0 - offset)
