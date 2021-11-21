extends Spatial

onready var environment :Environment = $Player/Camera.get_environment()
onready var obstacles :Spatial = $Obstacles
onready var camera :Camera = $Player/Camera
onready var player :MeshInstance = $Player
onready var player_collision :Area = $Player/Area
onready var points_collision :Area = $Player/PointsArea
onready var player_particles :CPUParticles = $Player/CPUParticles
onready var hud_score :Label = $hud/MarginContainer/HBoxContainer/ScoreContainer/ScoreLabel
onready var sky :ProceduralSky = $Player/Camera.get_environment().get_sky()

var sky_tween :Resource = preload("sky_tween.gd").new()

var tilt:float=0
var score :float = 0

var game_over :bool = false

func _ready():
	sky_tween.set_sky(sky)
	obstacles.connect("next_level", self, "advance_level")
	player_collision.connect("area_entered", self, "on_game_over")
	points_collision.connect("area_entered", self, "on_points_collect")
	reset()

func _physics_process(delta):
	var decay :float = 0.95
	
	if not game_over:
		if Input.is_action_pressed("ui_left"):
			tilt += 0.06
			decay *= decay
		elif Input.is_action_pressed("ui_right"):
			tilt -= 0.06
			decay *= decay
			
		score += 100*delta
		hud_score.set_text(str(int(score)))
		sky_tween.process(delta)
	elif Input.is_action_pressed("ui_select"):
		reset()
		
	tilt *= decay
	player.set_rotation(Vector3(0,0,tilt/1.5))
	obstacles.set_tilt(tilt)
	
func on_game_over(obstacle:Area):
	game_over = true
	obstacles.game_over = true
	player_particles.set_emitting(true)
	sky_tween.stop()
	
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

