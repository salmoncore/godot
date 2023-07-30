extends Node2D

var player
var velocity = 0

const ZOOM_OUT_MAX = Vector2(.3, .3)
const ZOOM_IN_MAX = Vector2(.7, .7)
const ZOOM_INCREMENT = Vector2(.001, .001)
var zoom = Vector2(.7, .7)
var mod = 0
var maxMod = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera.offset = player.position
		
	if playerVelocity() > 500:
		zoomOut()
	elif player.is_on_floor:
		zoomIn()
	
func zoomIn():
	zoom = zoom + ZOOM_INCREMENT
	zoomSet()
	
func zoomOut():
	zoom = zoom - ZOOM_INCREMENT
	zoomSet()
	
func playerVelocity():
	if abs(player.velocity.x) > abs(player.velocity.y):
		return abs(player.velocity.x)
	else:
		return abs(player.velocity.y)
	
func zoomSet():
	if zoom > ZOOM_IN_MAX:
		zoom = ZOOM_IN_MAX
	if zoom < ZOOM_OUT_MAX:
		zoom = ZOOM_OUT_MAX
	$Camera.set_zoom(zoom)
