extends Spatial

onready var environment :Environment = $Player/Camera.get_environment()
onready var obstacles :Spatial = $Obstacles
onready var camera :Camera = $Player/Camera
onready var player :MeshInstance = $Player
onready var player_collision :Area = $Player/Area
onready var points_collision :Area = $Player/PointsArea
onready var player_particles :CPUParticles = $Player/CPUParticles
onready var hud_score :Label = $hud/ScoreView/HBoxContainer/ScoreContainer/ScoreLabel
onready var high_score_name_label :Label = $hud/ScoreView/HBoxContainer/Label2
onready var high_score_label :Label = $hud/ScoreView/HBoxContainer/HiScoreContainer/HiScoreLabel
onready var score_view :Container = $hud/ScoreView
onready var final_score_view :Container = $hud/FinalScoreView
onready var final_score_label :Label = $hud/FinalScoreView/VBoxContainer/HBoxContainer/FinalScore
onready var high_score_label_final :Label = $hud/FinalScoreView/VBoxContainer/HBoxContainer2/HighScore
onready var high_score_label_final_name :Label = $hud/FinalScoreView/VBoxContainer/HBoxContainer2/Label2
onready var start_game_hud :Container = $hud/StartGameView
onready var sky :ProceduralSky = $Player/Camera.get_environment().get_sky()
onready var post_glitch :Spatial = $Player/Camera/PostGlitch
onready var post_glitch_timer :Timer = $Player/Camera/PostGlitch/Timer

const MAX_TILT:float = PI/5
const TILT_DECAY:float = 0.95
# This acceleration assumes decay is applied twice (^2) as (T+a)*d^2=T when T==1
const TILT_ACCELERATION:float = (1.0-pow(TILT_DECAY,2))/pow(TILT_DECAY,2)
const POINTS_PER_SECOND:float = 100.0

var sky_tween :Resource = preload("sky_tween.gd").new()

var tilt:float=0
var score :float = 0
var high_score :float = 0
var _high_score_run :bool = false

var game_over :bool = true

# This is needed if:
# The ship hits and obstacle giving +500 pts but game_over
# The game_over causes -500 pts. IF the +500 pts had made
# the game be a high_score_run, then the high score gets -500 pts
# erroniously. Because the +500 should never have happened.
# So we check for this
var _prev_high_score :float = 0

func _ready():
	sky_tween.set_sky(sky)
	obstacles.connect("next_level", self, "advance_level")
	player_collision.connect("area_entered", self, "on_game_over")
	points_collision.connect("area_entered", self, "on_points_collect")
	obstacles.relative_speed=0
	obstacles.set_game(self)
	post_glitch_timer.connect("timeout", self, "_hide_post_glitch")
	#reset()
	

func _physics_process(delta):
	var decay :float = TILT_DECAY
	
	if not game_over:
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			tilt += TILT_ACCELERATION
			decay *= decay
		elif Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			tilt -= TILT_ACCELERATION
			decay *= decay
			
		score += POINTS_PER_SECOND*delta
		hud_score.set_text(str(int(score)))
		if score > high_score:
			high_score = score
			_high_score_run = true
			high_score_label.set_text(str(int(high_score)))
		sky_tween.process(delta)
	elif Input.is_action_pressed("ui_select"):
		reset()
		
	tilt *= decay
	player.set_rotation(Vector3(0,0,tilt*MAX_TILT))
	obstacles.set_tilt(tilt)
	if score == high_score:
		high_score_label.add_color_override("font_color", Color("d7c141"))
		high_score_name_label.add_color_override("font_color", Color("d7c141"))
	
func on_game_over(obstacle_area:Area):
	game_over = true
	obstacles.game_over = true
	player_particles.set_emitting(true)
	sky_tween.stop()
	var obstacle = obstacle_area.get_parent()
	if not obstacle.points_enabled:
		score -= 500
		if _high_score_run:
			high_score -= 500
			prints(high_score, _prev_high_score)
			if high_score < _prev_high_score:
				high_score = _prev_high_score
				_high_score_run = false
	obstacle.points_enabled=false
	post_glitch_timer.stop()
	post_glitch.set_visible(true)
	post_glitch.get_surface_material(0).set_shader_param("shake_rate",0.4)
	score_view.set_visible(false)
	final_score_view.set_visible(true)
	if score > high_score:
		high_score = score
	final_score_label.set_text(str(int(score)))
	if _high_score_run:
		high_score_label_final.add_color_override("font_color", Color("d7c141"))
		high_score_label_final_name.add_color_override("font_color", Color("d7c141"))
	else:
		high_score_label_final.add_color_override("font_color", Color("FFFFFF"))
		high_score_label_final_name.add_color_override("font_color", Color("FFFFFF"))
	high_score_label_final.set_text(str(int(high_score)))
	high_score_label.set_text(str(int(high_score)))
	
func on_points_collect(obstacle_area:Area):
	if game_over: return
	var obstacle :MeshInstance = obstacle_area.get_parent()
	if obstacle.points_enabled:
		score += 500
		obstacle.points_enabled = false
		obstacle.soundfx.play(0)
		post_glitch.set_visible(true)
		post_glitch_timer.start(0.2)

func _hide_post_glitch():
	post_glitch.set_visible(false)
	
func reset():
	high_score_label.add_color_override("font_color", Color("FFFFFF"))
	high_score_name_label.add_color_override("font_color", Color("FFFFFF"))
	score = 0
	_high_score_run = false
	game_over = false
	obstacles.reset()
	player_particles.set_emitting(false)
	score_view.set_visible(true)
	final_score_view.set_visible(false)
	start_game_hud.set_visible(false)
	post_glitch.get_surface_material(0).set_shader_param("shake_rate",1.0)
	post_glitch.set_visible(false)
	sky_tween.stop()
	
	_prev_high_score = high_score

	sky.set_sky_top_color(obstacles.levels[0].SKY_TOP_COLOR)
	sky.set_sky_horizon_color(obstacles.levels[0].SKY_HORIZON_COLOR)
	sky.set_ground_horizon_color(obstacles.levels[0].GROUND_HORIZON_COLOR)
	sky.set_ground_bottom_color(obstacles.levels[0].GROUND_BOTTOM_COLOR)
	
	

func advance_level(old, new, fade:float):
	sky_tween.tween(old.SKY_TOP_COLOR, old.SKY_HORIZON_COLOR, 
					old.GROUND_BOTTOM_COLOR, old.GROUND_HORIZON_COLOR,
					new.SKY_TOP_COLOR, new.SKY_HORIZON_COLOR, 
					new.GROUND_BOTTOM_COLOR, new.GROUND_HORIZON_COLOR,
					old.LEVEL_FADE_OUT_TIME)

