extends Resource

const CONE_SCENE :PackedScene = preload("../../enemies/cone.tscn")

var SKY_TOP_COLOR :Color = Color("#f0d983")
var SKY_HORIZON_COLOR :Color = Color("#f36d7d")
var GROUND_HORIZON_COLOR :Color = Color("#c56ea8")
var GROUND_BOTTOM_COLOR :Color = Color("#8e6ae5")

var CONE_DENSITY :float = 1.1
var LEVEL_DURATION :float = 5.0
var LEVEL_POINTS :float = 500.0
var LEVEL_FADE_OUT_TIME :float = 4.0

var CONE_MOTION_PROB :float = 0
var CONE_VELOCITY_0 :float = 0
var CONE_VELOCITY_RANDOM :float = 0

var CONE_SCALE_X0 :float = 1
var CONE_SCALE_X_RANDOM :float = 0

var CONE_SCALE_Y0 :float = 1
var CONE_SCALE_Y_RANDOM :float = 0

var t :float = 0
var abs_t :float = 0
var is_loaded :bool = false

func initialize(obstacles:Spatial):
	t = 0
	abs_t = 0
	
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
	if randf() < CONE_MOTION_PROB: xmove = true
	
	# position the cone
	var x :float = (2*randf()-1)*max_spawn_x
	var z :float = max_spawn_z * (1.0 + (randf()-0.5)/12.0) # a little random depth
	cone.translate(Vector3(obs_x + x, 0, -obs_z-z)) # random position left/right
	
	cone.rand_color()
	cone.rand_xspeed(CONE_VELOCITY_0, CONE_VELOCITY_RANDOM)
	cone.rand_scale(CONE_SCALE_X0, CONE_SCALE_X_RANDOM,
					CONE_SCALE_Y0, CONE_SCALE_Y_RANDOM)
	
	return cone

func fade_in():
	pass
	
func fade_out():
	pass
