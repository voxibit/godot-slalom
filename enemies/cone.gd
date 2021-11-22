extends MeshInstance

onready var timer :Timer = $Timer
var points_enabled :bool = true
var xspeed :float

func rando(xmove:bool=false):
	var color :Color = Color(randf(),randf(),randf(),1)
	get_surface_material(0).set_shader_param("color", color)
	if xmove:
		xspeed = (2*randf()-1)*3
	else:
		xspeed = 0
		
func rand_color():
	var color :Color = Color(randf(),randf(),randf(),1)
	get_surface_material(0).set_shader_param("color", color)

func rand_xspeed(vx0:float, vxrand:float):
	xspeed = vx0 + randf()*vxrand
	if randf() < 0.5: xspeed *= -1
	
func rand_scale(x0, xrand, y0, yrand):
	var xscale :float = x0 + xrand*randf()
	var yscale :float = y0 + yrand*randf()
	translate(Vector3(0,yscale-1, 0))
	set_scale(Vector3(xscale,yscale,1))
	
func _ready():
	timer.start(4)
	var parent = get_parent()
	if parent!=null:
		timer.connect("timeout", parent, "remove_child", [self])
		

func _physics_process(delta):
	translate(Vector3(xspeed/get_scale().x*delta, 0, 0))
