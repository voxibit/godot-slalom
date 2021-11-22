extends Resource

const CONE_SCENE :PackedScene = preload("../../enemies/cone.tscn")

var SKY_TOP_COLOR :Color = Color(0.64, 0.3, 0.2, 1.0)
var SKY_HORIZON_COLOR :Color = Color(0.8, 0.5, 0.4, 1.0)
var GROUND_HORIZON_COLOR :Color = Color(0.8, 0.5, 0.4, 1.0)
var GROUND_BOTTOM_COLOR :Color = Color(0.0, 0.0, 0.2, 1.0)

var CONES_PER_SECOND :float = 20.0
var LEVEL_DURATION :float = 30.0
var LEVEL_FADE_OUT_TIME :float = 4.0

var FUNNEL_IN_TIME :float = 3.0
var FUNNEL_OUT_TIME :float = 3.0

var FUNNEL_WIDTH :float = 20.0
var TUNNEL_WIDTH :float = 4.2

var TURN_SIZE_0 :float = 5
var TURN_SIZE_RAND :float = 5
var TURN_DURATION_0 :float = 1
var TURN_DURATION_RAND :float = 0.5

var t :float = 0 # for cone spawning
var path_t :float = 0 # for path turning
var abs_t :float = 0 # for path width funneling and exiting the level

var _prev_path_x :float
var _next_path_x :float
var _path_duration :float

var left :bool # cone spawns on left of path, VS right
var turn_left :bool # path takes a turn to the left, VS right

var x0 :float
var is_loaded :bool = false

var _max_slope :float = 1
var _obstacle_speed :float = 1

func initialize(obstacle_parent:Spatial):
	t = 0
	path_t = 0
	abs_t = 0
	_prev_path_x = 0
	_next_path_x = 0
	_path_duration = FUNNEL_IN_TIME
	x0 = -obstacle_parent.get_translation().x
	
	_obstacle_speed = obstacle_parent.SPEED
	_max_slope = obstacle_parent.MAX_HORIZONTAL_DIR / obstacle_parent.direction.z
	
func renormalize_positions(translation:Vector3):
	x0 += translation.x
	
func process(delta:float, obs_x:float, obs_z:float, max_spawn_x:float, max_spawn_z:float):
	t += delta
	path_t += delta
	abs_t += delta
	if t > 1.0/CONES_PER_SECOND:
		t = 0
		return _spawn_cone(obs_x, obs_z, max_spawn_x, max_spawn_z)

func _next_step():
	_prev_path_x = _next_path_x
	_path_duration = TURN_DURATION_0 + randf()*TURN_DURATION_RAND
	
	# don't turn if we are within funnel_out_time
	if abs_t < LEVEL_DURATION-FUNNEL_OUT_TIME:
		var z_distance = _path_duration*_obstacle_speed
		# turn_size is within [0...1], where 1 equals z_dist*slope
		var turn_size = TURN_SIZE_0 + TURN_SIZE_RAND*randf()
		turn_size *= (_max_slope*z_distance)
		
		if turn_left:
			_next_path_x -= turn_size
			turn_left = false
		else:
			_next_path_x += turn_size
			turn_left = true
	path_t = 0

func _spawn_cone(obs_x:float, obs_z:float, max_spawn_x:float, max_spawn_z:float) -> MeshInstance:
	
	# Get next step in path if needed
	if path_t > _path_duration:
		_next_step()
	
	# get the path width (allows funneling in / out)
	var width :float
	if abs_t < FUNNEL_IN_TIME:
		width = lerp(FUNNEL_WIDTH, TUNNEL_WIDTH, abs_t/FUNNEL_IN_TIME)
	elif abs_t > LEVEL_DURATION - FUNNEL_OUT_TIME:
		width = lerp(TUNNEL_WIDTH, FUNNEL_WIDTH, (abs_t-LEVEL_DURATION+FUNNEL_OUT_TIME)/FUNNEL_OUT_TIME)
	else: width = TUNNEL_WIDTH

	# Create a cone at max_spawn_z distance, and get central position of path
	var cone = CONE_SCENE.instance()
	var z :float = max_spawn_z
	var _path_x :float = _get_path_x()
	
	# Get the x we will give the object
	var x :float
	if left:
		x = _path_x - width/2.0
		left = false
	else:
		x = _path_x + width/2.0
		left = true
	
	cone.translate(Vector3(x0 + x, 0, -obs_z-z))
	cone.rando()
	#cone.set_scale(Vector3(2,1,1))
	
	return cone

func _get_path_x() -> float:
	return lerp(_prev_path_x, _next_path_x, path_t/_path_duration)

func setup():
	pass
