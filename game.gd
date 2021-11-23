extends Spatial

onready var environment :Environment = $Player/Camera.get_environment()
onready var obstacles :Spatial = $Obstacles
onready var camera :Camera = $Player/Camera
onready var player :MeshInstance = $Player
onready var player_collision :Area = $Player/Area
onready var points_collision :Area = $Player/PointsArea
onready var player_particles :CPUParticles = $Player/CPUParticles
onready var hud_score :Label = $hud/ScoreView/HBoxContainer/ScoreContainer/ScoreLabel
onready var high_score_label :Label = $hud/ScoreView/HBoxContainer/HiScoreContainer/HiScoreLabel
onready var score_view :Container = $hud/ScoreView
onready var final_score_view :Container = $hud/FinalScoreView
onready var final_score_label :Label = $hud/FinalScoreView/VBoxContainer/HBoxContainer/FinalScore
onready var high_score_label_final :Label = $hud/FinalScoreView/VBoxContainer/HBoxContainer2/HighScore
onready var start_game_hud :Container = $hud/StartGameView
onready var sky :ProceduralSky = $Player/Camera.get_environment().get_sky()

const MAX_TILT:float = PI/6
const TILT_DECAY:float = 0.95
# This acceleration assumes decay is applied twice (^2) as (T+a)*d^2=T when T==1
const TILT_ACCELERATION:float = (1.0-pow(TILT_DECAY,2))/pow(TILT_DECAY,2)

var sky_tween :Resource = preload("sky_tween.gd").new()

var tilt:float=0
var score :float = 0
var high_score :float = 0

var game_over :bool = true

func _ready():
	sky_tween.set_sky(sky)
	obstacles.connect("next_level", self, "advance_level")
	player_collision.connect("area_entered", self, "on_game_over")
	points_collision.connect("area_entered", self, "on_points_collect")
	obstacles.relative_speed=0
	#reset()
	

func _physics_process(delta):
	var decay :float = TILT_DECAY
	
	if not game_over:
		if Input.is_action_pressed("ui_left"):
			tilt += TILT_ACCELERATION
			decay *= decay
		elif Input.is_action_pressed("ui_right"):
			tilt -= TILT_ACCELERATION
			decay *= decay
		elif Input.is_action_just_pressed("ui_cancel"):
			obstacles.skip()
			
		score += 100*delta
		hud_score.set_text(str(int(score)))
		if score > high_score:
			high_score = score
			high_score_label.set_text(str(int(high_score)))
		sky_tween.process(delta)
	elif Input.is_action_pressed("ui_select"):
		reset()
		
	tilt *= decay
	player.set_rotation(Vector3(0,0,tilt*MAX_TILT))
	obstacles.set_tilt(tilt)
	
func on_game_over(obstacle:Area):
	game_over = true
	obstacles.game_over = true
	player_particles.set_emitting(true)
	sky_tween.stop()
	score_view.set_visible(false)
	final_score_view.set_visible(true)
	if score > high_score:
		high_score = score
	final_score_label.set_text(str(int(score)))
	high_score_label_final.set_text(str(int(high_score)))
	high_score_label.set_text(str(int(high_score)))
	
func on_points_collect(obstacle_area:Area):
	if game_over: return
	var obstacle :MeshInstance = obstacle_area.get_parent()
	if obstacle.points_enabled:
		score += 500
		obstacle.points_enabled = false
	
func reset():
	score = 0
	game_over = false
	obstacles.reset()
	player_particles.set_emitting(false)
	score_view.set_visible(true)
	final_score_view.set_visible(false)
	start_game_hud.set_visible(false)

	sky.set_sky_top_color(obstacles.levels[0].SKY_TOP_COLOR)
	sky.set_sky_horizon_color(obstacles.levels[0].SKY_HORIZON_COLOR)
	sky.set_ground_horizon_color(obstacles.levels[0].GROUND_HORIZON_COLOR)
	sky.set_ground_bottom_color(obstacles.levels[0].GROUND_BOTTOM_COLOR)

func advance_level(old, new, fade:float):
	print("___ADVANCE LEVEL___")
	sky_tween.tween(old.SKY_TOP_COLOR, old.SKY_HORIZON_COLOR, 
					old.GROUND_BOTTOM_COLOR, old.GROUND_HORIZON_COLOR,
					new.SKY_TOP_COLOR, new.SKY_HORIZON_COLOR, 
					new.GROUND_BOTTOM_COLOR, new.GROUND_HORIZON_COLOR,
					old.LEVEL_FADE_OUT_TIME)

