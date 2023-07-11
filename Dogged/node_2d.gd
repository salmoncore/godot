extends Node2D

var selectNode

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if selectNode != null:
		if Input.is_action_pressed("key_right"):
			$Torso/Neck.rotation_degrees += 1
		if Input.is_action_pressed("key_left"):
			selectNode.rotation_degrees -= 1
	
	pass


func _on_torso_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		selectNode = get_node("Torso")
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		selectNode = null

func _on_neck_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		selectNode = get_node("Torso/Neck")
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		selectNode = null
