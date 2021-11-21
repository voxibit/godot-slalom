extends MeshInstance

onready var timer :Timer = $Timer
var points_enabled :bool = true
var xspeed :float

func rando():
	var color :Color = Color(randf(),randf(),randf(),1)
	get_surface_material(0).set_shader_param("color", color)
	xspeed = (2*randf()-1)*3
	
func _ready():
	timer.start(2)
	var parent = get_parent()
	if parent!=null:
		timer.connect("timeout", parent, "remove_child", [self])
		

func _physics_process(delta):
	translate(Vector3(xspeed/get_scale().x*delta, 0, 0))
	
