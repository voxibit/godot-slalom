extends "templates/tunnel.gd"

func setup():
	SKY_TOP_COLOR = Color(0.24, 0.73, 0.84, 1.0)
	SKY_HORIZON_COLOR = Color(0.73, 0.81, 0.88, 1.0)
	GROUND_HORIZON_COLOR = Color(0.89, 0.98, 0.83, 1.0)
	GROUND_BOTTOM_COLOR = Color(0.24, 0.43, 0.15, 1.0)

	TUNNEL_WIDTH = 4.5
	LEVEL_POINTS = 7000

	# best to keep these summing to <= 1, or impossible turns can come up
	TURN_SIZE_0 = 0.5
	TURN_SIZE_RAND = 0.4 
	
	TURN_DURATION_0 = 0.5
	TURN_DURATION_RAND = 0.8
	
