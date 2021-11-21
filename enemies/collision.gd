extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", self, "collide")

func collide(other:Area):
	var particles :CPUParticles = get_parent().get_node("CPUParticles")
	particles.set_emitting(true)
	emit_signal("gameover")
