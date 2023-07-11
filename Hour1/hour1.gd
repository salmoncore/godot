extends Node2D

var time;
var formattedtime;
var stopflag = 0;
var angle360;

# Called when the node enters the scene tree for the first time.
func _ready():
	time = (randi() % 13 + 1)
	#print(time)
	formattedtime = str(time) + ":00"
	#print(formattedtime)
	$DigitalClock.clear()
	$DigitalClock.add_text(formattedtime)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!stopflag):
		$Hand.rotation_degrees += delta*150
	
	angle360 = ((int($Hand.rotation_degrees) % 360) + 1)
	
	if Input.is_action_pressed("Stop"):
		stopflag = 1
		if angle360 > (15 + (time*30)) or angle360 < (15 - (time*30)):
			print("yey")
			print(angle360)
			print((1/30) * angle360)
		else:
			print("aw")
			print(angle360)
			print((1/30) * angle360)
	
	pass
