extends MeshInstance

onready var timer :Timer = $Timer
onready var points_timer :Timer = $PointsTimer
var soundfx :AudioStreamPlayer3D setget ,get_soundfx
var points_enabled :bool = true
var xspeed :float
var zspeed :float
var caused_game_over :bool = false

var sounds :Array = []

func rando(xmove:bool=false):
	var color :Color = Color(randf(),randf(),randf(),1)
	get_surface_material(0).set_shader_param("color", color)
	if xmove:
		xspeed = (2*randf()-1)*3
	else:
		xspeed = 0
		
func rand_color(emit:float=0):
	var mat :SpatialMaterial = get_surface_material(0)
	var color :Color = Color(randf(),randf(),randf(),1)
	mat.set_albedo(color)
	if emit>0:
		mat.set_feature(SpatialMaterial.FEATURE_EMISSION,true)
		mat.set_emission(color)
		mat.set_emission_energy(emit)
	#get_surface_material(0).set_shader_param("color", color)
	

func rand_xspeed(vx0:float, vxrand:float):
	xspeed = vx0 + randf()*vxrand
	if randf() < 0.5: xspeed *= -1
	
func rand_zspeed(vz0:float, vzrand:float):
	zspeed = vz0 + randf()*vzrand
	
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
	for child in get_children():
		if child is AudioStreamPlayer3D:
			sounds.append(child)
	points_timer.connect("timeout", self, "on_points")
		

func _physics_process(delta):
	translate(Vector3(xspeed/get_scale().x*delta, 0, zspeed/get_scale().z*delta))

func get_soundfx():
	#return $AudioStreamPlayer3D
	return sounds[randi() % len(sounds)]
	
func on_points():
	remove_child(points_timer)
	get_parent().get_parent().on_points_timer(self)
