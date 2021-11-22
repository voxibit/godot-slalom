extends Resource

const CONE_SCENE :PackedScene = preload("../enemies/cone.tscn")
const EVIL_CONE :PackedScene = preload("../enemies/evil_cone.tscn")

const SKY_TOP_COLOR :Color = Color("#f0d983")
const SKY_HORIZON_COLOR :Color = Color("#f36d7d")
const GROUND_HORIZON_COLOR :Color = Color("#c56ea8")
const GROUND_BOTTOM_COLOR :Color = Color("#8e6ae5")

const CONE_DENSITY :float = 0.9
const LEVEL_DURATION :float = 5.0
const LEVEL_FADE_OUT_TIME :float = 4.0

var t :float = 0
var abs_t :float = 0
var is_loaded :bool = false

func initialize(obstacles:Spatial):
	t = 0
	
func renormalize_positions(translation:Vector3):
	pass

func process(delta:float, obs_x:float, obs_z:float, max_spawn_x:float, max_spawn_z:float):
	t += delta
	if t > 1.0/(CONE_DENSITY*max_spawn_x):
		t = 0
		return _spawn_cone(obs_x, obs_z, max_spawn_x, max_spawn_z)

func _spawn_cone(obs_x:float, obs_z:float, max_spawn_x:float, max_spawn_z:float) -> MeshInstance:
	var cone = CONE_SCENE.instance()
	var xmove :bool = false
	if randf() < 0.8: xmove = true
	
	var x :float = (2*randf()-1)*max_spawn_x
	var z :float = max_spawn_z * (1.0 + (randf()-0.5)/12.0)
	cone.translate(Vector3(obs_x + x, 0, -obs_z-z))
	cone.rando(xmove)
	
	var xscale :float = 1 + 1*randf()
	var yscale :float = 1 + 1*randf()
	cone.translate(Vector3(0,yscale-1, 0))
	cone.set_scale(Vector3(xscale,yscale,1))
	
	return cone

func setup():
	pass
