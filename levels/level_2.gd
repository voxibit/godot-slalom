extends "templates/basic.gd"

func setup():
	SKY_TOP_COLOR = Color(0.64, 0.5, 0.4, 1.0)
	SKY_HORIZON_COLOR = Color(0.8, 0.6, 0.5, 1.0)
	GROUND_HORIZON_COLOR = Color(0.8, 0.6, 0.5, 1.0)
	GROUND_BOTTOM_COLOR = Color(0.20, 0.3, 0.1, 1.0)

	CONE_DENSITY = 1.0
	LEVEL_DURATION = 30.0
	LEVEL_FADE_OUT_TIME = 4.0
