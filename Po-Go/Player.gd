extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const BOUNCE_ANGLE = 70
const FRICTION = .95

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var bounceFlag : bool = false
var prevVelocity

func _physics_process(delta):
	
	if not is_on_floor():
		# Gravity
		velocity.y += gravity * delta
		prevVelocity = velocity.y
		if Input.is_action_just_pressed("Cancel"):
				bounceFlag = false
	else:
		# If not bouncing, apply friction and listen for jump.
		if bounceFlag == true:
			# Bounce
			if abs(rotation_degrees) < BOUNCE_ANGLE:
				velocity.y = -1.25 * prevVelocity
				velocity.x = (rotation_degrees * .1) * (prevVelocity * .2)
			else:
				bounceFlag = false
		
		else:
			# Friction
			if abs(velocity.x) > 0:
				velocity.x = velocity.x * FRICTION
				print(velocity.x)
		
			# Jump Handler
			if Input.is_action_pressed("Jump"):
				bounceFlag = true
				# Make the jump animation happen here
				if abs(rotation_degrees) < BOUNCE_ANGLE:
					velocity.y = JUMP_VELOCITY
					velocity.x = rotation_degrees 
		
	if Input.is_action_pressed("Rotate Right"):
		rotation_degrees += 4
	elif Input.is_action_pressed("Rotate Left"):
		rotation_degrees -= 4

	move_and_slide()
