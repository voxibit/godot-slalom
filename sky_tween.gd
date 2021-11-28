extends Resource

# This script transitions the environment sky from level to level
# From the docs, recalculating the sky should happen infrequently,
# as it is expensive. A regular tween caused unacceptable performance.
# This script tweens at 5 fps (0.2 frames per second) at most.
# If a transition lasts more than 2 seconds, only 10 frames are
# calculated, at a lower fps than 5.

const _MAX_FRAMES = 10
const _SECONDS_PER_FRAME :float = 0.2
var _spf :float

var abs_t :float # used for tracking whole progress
var t :float # used to determine when to update sky
var duration :float # how long the whole transition should last
var sky :ProceduralSky
var processing :bool = false

var sky_top :Array = [Color.aliceblue, Color.aliceblue]
var sky_horizon :Array = [Color.aliceblue, Color.aliceblue]
var ground_bottom :Array = [Color.aliceblue, Color.aliceblue]
var ground_horizon :Array = [Color.aliceblue, Color.aliceblue]

func tween(old_sky_top:Color, old_sky_horizon:Color, old_ground_bottom:Color, old_ground_horizon:Color,
		   new_sky_top:Color, new_sky_horizon:Color, new_ground_bottom:Color, new_ground_horizon:Color,
		   duration:float):
	self.duration = duration
	self.t = 0
	sky_top = [old_sky_top, new_sky_top]
	sky_horizon = [old_sky_horizon, new_sky_horizon]
	ground_bottom = [old_ground_bottom, new_ground_bottom]
	ground_horizon = [old_ground_horizon, new_ground_horizon]
	
	var min_seconds_per_frame = duration / _MAX_FRAMES
	if min_seconds_per_frame > _SECONDS_PER_FRAME:
		_spf = min_seconds_per_frame
	else:
		_spf = _SECONDS_PER_FRAME
	start()

func process(delta:float):
	if not processing: return
	abs_t += delta
	if abs_t > duration:
		_color_sky()
		stop()
	else:
		t += delta
		if t > _spf:
			t = 0
			_color_sky()
	
func set_sky(sky:ProceduralSky):
	self.sky = sky
	
func _color_sky():
	sky.set_sky_top_color(lerp(sky_top[0], sky_top[1], abs_t/duration))
	sky.set_sky_horizon_color(lerp(sky_horizon[0], sky_horizon[1], abs_t/duration))
	sky.set_ground_bottom_color(lerp(ground_bottom[0], ground_bottom[1], abs_t/duration))
	sky.set_ground_horizon_color(lerp(ground_horizon[0], ground_horizon[1], abs_t/duration))

func start():
	processing = true
	
func stop():
	processing = false
	reset()

func reset():
	abs_t = 0
	t = 0
