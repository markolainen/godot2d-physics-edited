extends Node2D

export var jump_thru = false
onready var hitbox = $Hitbox

func _ready():
	add_to_group("Walls")
	# I had to add the divisor for the hitbox to draw correctly, if you remove
	# the hitbox visibility you can probably remove the divisors too.
	hitbox.width *= scale.x
	hitbox.divisor_x *= scale.x
	hitbox.height *= scale.y
	hitbox.divisor_y *= scale.y
