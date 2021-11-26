extends Spatial

signal next_level(old_level, new_level, fade_time)

const SPEED :float = 12.0
const _SPAWN_DISTANCE_Z :float = 20.0
const _SPAWN_DISTANCE_X :float = 20.0
const MAX_HORIZONTAL_DIR :float = 1.0

var direction :Vector3 = Vector3(0,0,1)

var game_over :bool = false setget set_game_over, get_game_over
var game :Spatial
var score0 :float = 0.0
var relative_speed :float = 1

var levels :Array
var curr_level
var level_index :int = 0

var t :float = 0
var _start_next_level_advance :bool = false

func _ready():
	levels = []
	for lvl in ['1','2x','2','4x','4','6x', '5', '8x']:
		var loaded_level = load("levels/level_%s.gd"%lvl).new()
		loaded_level.setup()
		levels.append(loaded_level)
	translate(Vector3(10,0,0)) #???

func _physics_process(delta):
	if game_over: relative_speed *= pow(0.2,delta)
	translate(direction*SPEED*delta*relative_speed)
	
	var z :float = get_translation().z
	if z > 10:
		pass
		_renormalize_positions(z)
	
	curr_level = _get_level()
	
	if not game_over:
		if _start_next_level_advance: t += delta
		var spawn = curr_level.process(delta, get_translation().x, get_translation().z, 1.5*_SPAWN_DISTANCE_X, _SPAWN_DISTANCE_Z)
		if spawn != null:
			add_child(spawn)

func set_game(game:Spatial):
	self.game = game

func _get_level():
	var curr_level = levels[level_index]
	var level = curr_level
	
	# Start transition to new level
	if (game.score-score0) > curr_level.LEVEL_POINTS		and \
						 t < curr_level.LEVEL_FADE_OUT_TIME	and \
			   level_index < len(levels)-1:
		if not _start_next_level_advance:
			_start_next_level_advance = true
			emit_signal("next_level", levels[level_index], levels[level_index+1], levels[level_index].LEVEL_FADE_OUT_TIME)
			levels[level_index].fade_out()
			levels[level_index+1].fade_in()
			t = 0
		# Randomly pick prev or next level to spawn enemies from
		var fade_t = t - curr_level.LEVEL_FADE_OUT_TIME
		var _rand = randf()
		if _rand < fade_t/curr_level.LEVEL_FADE_OUT_TIME:
			level = levels[level_index + 1]
		else:
			level = curr_level
	
	# Complete transition and completely switch to new level
	elif (game.score-score0) > curr_level.LEVEL_POINTS			and \
						 t >= curr_level.LEVEL_FADE_OUT_TIME	and \
			   level_index < len(levels)-1:
		_start_next_level_advance = false
		t = 0
		level_index += 1
		level = levels[level_index]
		score0 = game.score

	if !level.is_loaded:
		level.is_loaded = true
		level.initialize(self)
	return level

	
func _renormalize_positions(z:float):
	curr_level.renormalize_positions(get_translation())
	var x :float = get_translation().x
	set_translation(Vector3(0,0,0))
	for child in get_children():
		child.translate(Vector3(x/child.get_scale().x,0,z))

func set_tilt(tilt:float):
	direction.x = tilt*MAX_HORIZONTAL_DIR

func set_game_over(go):
	game_over = go
	if game_over:
		for child in get_children():
			var timer :Timer = child.get_node("Timer")
			timer.stop()
		
func get_game_over():
	return game_over

func reset():
	game_over = false
	t = 0
	score0 = 0
	level_index = 0
	_start_next_level_advance = false
	relative_speed = 1
	for child in get_children():
		remove_child(child)
	set_translation(Vector3(0,0,0))
	for level in levels:
		level.is_loaded = false
	curr_level = levels[0]
	
func skip():
	t = curr_level.LEVEL_DURATION - curr_level.LEVEL_FADE_OUT_TIME
	curr_level.abs_t = t

