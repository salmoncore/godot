extends Node2D

var player
var maxVelocity = 0

const ZOOM_IN_MAX = Vector2(1, 1)
const ZOOM_OUT_MAX = Vector2(.3, .3)
const ZOOM_STANDARD = Vector2(.7, .7)
var zoom = Vector2(.8, .8)
var mod = 0
var maxMod = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera.offset = player.position
	
	if abs(player.velocity.x) > abs(player.velocity.y):
		maxVelocity = abs(player.velocity.x)
	else:
		maxVelocity = abs(player.velocity.y)
		
#	print(maxVelocity)
	
	if maxVelocity > 500:
		mod = abs(maxVelocity - 500) / 100000
		
		if mod > maxMod:
			maxMod = mod
			print(maxMod)
		
		zoom.x = zoom.x - maxMod
		zoom.y = zoom.y - maxMod
		
		if zoom > ZOOM_IN_MAX:
			zoom = ZOOM_IN_MAX
		if zoom < ZOOM_OUT_MAX:
			zoom = ZOOM_OUT_MAX
			
	elif player.is_on_floor:
		mod = abs(500 - maxVelocity) / 10000
		zoom.x = zoom.x + mod
		zoom.y = zoom.y + mod
		
		if zoom > ZOOM_IN_MAX:
			zoom = ZOOM_IN_MAX
		if zoom < ZOOM_OUT_MAX:
			zoom = ZOOM_OUT_MAX
		
	$Camera.set_zoom(zoom)
