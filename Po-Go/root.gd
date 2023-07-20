extends Node2D

var player
var maxVelocity = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera.offset = player.position
	$Camera.set_zoom(Vector2(0.8, 0.8))
