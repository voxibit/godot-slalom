extends "templates/basic.gd"

func setup():
	SKY_TOP_COLOR = Color(0.64, 0.83, 0.94, 1.0)
	SKY_HORIZON_COLOR = Color(0.83, 0.91, 0.98, 1.0)
	GROUND_HORIZON_COLOR = Color(0.89, 0.98, 0.83, 1.0)
	GROUND_BOTTOM_COLOR = Color(0.24, 0.43, 0.15, 1.0)

	CONE_DENSITY = 0.6
	LEVEL_DURATION = 15.0
	LEVEL_FADE_OUT_TIME = 4.0
