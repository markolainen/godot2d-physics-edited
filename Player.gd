extends "res://Scripts/Actor.gd"
onready var animated_sprite = $AnimatedSprite
onready var hitbox = $Hitbox

var velocity = Vector2.ZERO
var max_run = 100
var run_accel = 800
var gravity = 1000
var max_fall = 160
var jump_force = -160
var jump_hold_time = 0.2
var local_hold_time = 0

# Added variables
var coyote_time = .3 # in seconds
var coyote_timer = 0
var jump_buffering_time = .3 # in seconds
var jump_buffering_timer = jump_buffering_time

func _process(delta):
	
	var direction = sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))	
	var on_ground = Game.check_walls_collision(self, Vector2.DOWN)
	
	var jumping = Input.is_action_just_pressed("jump")
	# coyote_timer < coyote_time substitutes on_ground check since coyote_time
	# is only 0 if we recently stood on ground
	# The check to the right of or checks if we recently pressed jump button while in air
	if (jumping && coyote_timer < coyote_time) or (jump_buffering_timer < jump_buffering_time and on_ground):
		velocity.y = jump_force
		local_hold_time = jump_hold_time
	elif local_hold_time > 0:
		if Input.is_action_pressed("jump"):
			velocity.y = jump_force
		else:
			local_hold_time = 0
	
	local_hold_time -= delta
	
	# Reset coyote timer if we're ground, else decrease it
	if on_ground and not jumping:
		coyote_timer = 0
	else:
		coyote_timer += delta
	# If we're falling and try to jump reset jump buffering timer
	if jumping and velocity.y > 0:
		jump_buffering_timer = 0
	# Increase jump buffering timer
	jump_buffering_timer += delta
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	if direction != 0:
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Idle")
	
	velocity.x = move_toward(velocity.x, max_run * direction, run_accel * delta)
	velocity.y = move_toward(velocity.y, max_fall, gravity * delta)
	
	move_x(velocity.x * delta, funcref(self, "on_collision_x"))
	move_y(velocity.y * delta, funcref(self, "on_collision_y"))

func on_collision_x():
	velocity.x = 0
	zero_remainder_x()
func on_collision_y():
	velocity.y = 0
	zero_remainder_y()
	
func is_riding(solid, offset):
	return !hitbox.intersects(solid.hitbox, Vector2.ZERO) && hitbox.intersects(solid.hitbox, offset)

func squish():
	print("squished")
	
	
	
