extends Resource

const CONE_SCENE :PackedScene = preload("../enemies/cone.tscn")

const SKY_TOP_COLOR :Color = Color(0.64, 0.83, 0.94, 1.0)
const SKY_HORIZON_COLOR :Color = Color(0.83, 0.91, 0.98, 1.0)
const GROUND_HORIZON_COLOR :Color = Color(0.89, 0.98, 0.83, 1.0)
const GROUND_BOTTOM_COLOR :Color = Color(0.24, 0.43, 0.15, 1.0)

const CONES_PER_SECOND :float = 12.0
const LEVEL_DURATION :float = 15.0
const LEVEL_FADE_OUT_TIME :float = 4.0

var t :float = 0
var is_loaded :bool = false

func initialize(obstacles:Spatial):
	t = 0
	
func renormalize_positions(translation:Vector3):
	pass

func process(delta:float, obs_x:float, obs_z:float, max_spawn_x:float, max_spawn_z:float):
	t += delta
	if t > 1.0/CONES_PER_SECOND:
		t = 0
		return _spawn_cone(obs_x, obs_z, max_spawn_x, max_spawn_z)

func _spawn_cone(obs_x:float, obs_z:float, max_spawn_x:float, max_spawn_z:float) -> MeshInstance:
	var cone = CONE_SCENE.instance()
	var x :float = (2*randf()-1)*max_spawn_x
	var z :float = max_spawn_z * (1.0 + (randf()-0.5)/12.0)
	cone.translate(Vector3(obs_x + x, 0, -obs_z-z))
	cone.rando()
	
	return cone
