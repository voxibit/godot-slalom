extends "templates/tunnel.gd"

func setup():
	SKY_TOP_COLOR = Color(0.64, 0.3, 0.2, 1.0)
	SKY_HORIZON_COLOR = Color(0.8, 0.5, 0.4, 1.0)
	GROUND_HORIZON_COLOR = Color(0.8, 0.5, 0.4, 1.0)
	GROUND_BOTTOM_COLOR = Color(0.0, 0.0, 0.2, 1.0)

	LEVEL_DURATION = 30.0
	LEVEL_FADE_OUT_TIME = 4.0

	FUNNEL_IN_TIME = 3.0
	FUNNEL_OUT_TIME = 3.0

	FUNNEL_WIDTH = 50.0
	TUNNEL_WIDTH = 6.0

	# best to keep these summing to <= 1, or impossible turns can come up
	TURN_SIZE_0 = 0.4
	TURN_SIZE_RAND = 0.5 
	
	TURN_DURATION_0 = 0.8
	TURN_DURATION_RAND = 0.8
