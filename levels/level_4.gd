extends "templates/tunnel.gd"

func setup():
	SKY_TOP_COLOR = Color(0.24, 0.14, 0.24, 1.0)
	SKY_HORIZON_COLOR = Color(0.33, 0.11, 0.18, 1.0)
	GROUND_HORIZON_COLOR = Color(0.30, 0.48, 0.33, 1.0)
	GROUND_BOTTOM_COLOR = Color(0.14, 0.23, 0.15, 1.0)

	TUNNEL_WIDTH = 5

	# best to keep these summing to <= 1, or impossible turns can come up
	TURN_SIZE_0 = 0.4
	TURN_SIZE_RAND = 0.5 
	
	TURN_DURATION_0 = 0.8
	TURN_DURATION_RAND = 0.8
	
	CONE_EMISSIVITY = 0.6
