extends Node2D

var selectNode
var selectSprite
var poseNode
var poseSprite
var partArray = ["Torso", "Torso/Neck", "Torso/Neck/Head", "Torso/Neck/Head/Ear", "Torso/Back", "Torso/Back/LegBackR",
				 "Torso/Back/LegBackL", "Torso/Back/TailSection1", "Torso/Back/TailSection1/TailSection2", 
				 "Torso/Back/TailSection1/TailSection2/TailSection3", "Torso/LegFrontR", "Torso/LegFrontL"]
var poseArray = ["PoseTorso", "PoseTorso/Neck", "PoseTorso/Neck/Head", "PoseTorso/Neck/Head/Ear", "PoseTorso/Back", "PoseTorso/Back/LegBackR",
				 "PoseTorso/Back/LegBackL", "PoseTorso/Back/TailSection1", "PoseTorso/Back/TailSection1/TailSection2", 
				 "PoseTorso/Back/TailSection1/TailSection2/TailSection3", "PoseTorso/LegFrontR", "PoseTorso/LegFrontL"]
var partIndex = 0
var posePositions = [0,0,0,0,0,0,0,0,0,0,0,0]
var jointScores = [0,0,0,0,0,0,0,0,0,0,0,0]
var scoreTotal = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Poses the dog
	poseRandomizer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	dogPoser()
	
	# Reset function
	if Input.is_action_just_pressed("key_confirm"):
		dogGrader()
#		for i in range(12):
#			selectNode = get_node(partArray[i])
#			poseNode = get_node(poseArray[i])
#			selectNode.rotation_degrees = 0
#			poseNode.rotation_degrees = 0
#		poseRandomizer()
#		dogPoser()
	
	# Handle input for part selection
	if Input.is_action_just_pressed("key_up"):
		selectSprite.modulate = Color(1,1,1)
		if partIndex == 11:
			partIndex = 0
		else:
			partIndex += 1
		selectNode = get_node(partArray[partIndex])
		selectSprite = get_node(partArray[partIndex] + "/Sprite2D")
		selectSprite.modulate = Color(3,3,3)
	if Input.is_action_just_pressed("key_down"):
		selectSprite.modulate = Color(1,1,1)
		if partIndex == 0:
			partIndex = 11
		else:
			partIndex -= 1
		selectNode = get_node(partArray[partIndex])
		selectSprite = get_node(partArray[partIndex] + "/Sprite2D")
		selectSprite.modulate = Color(3,3,3)
	
	# Handle input for part rotation
	if selectNode != null:
		if Input.is_action_pressed("key_right"):
			selectNode.rotation_degrees += 1
		if Input.is_action_pressed("key_left"):
			selectNode.rotation_degrees -= 1

func poseRandomizer():
	randomize()
	
	selectNode = get_node("Torso")
	selectSprite = get_node(partArray[partIndex] + "/Sprite2D")
	
	for i in range(12):
		# Colors pose dog a tan-y? color? ?
		poseNode = get_node(poseArray[i])
		poseSprite = get_node(poseArray[i] + "/Sprite2D")
		poseSprite.modulate = Color(15,5,.5)
		# Randomly rotates the dog's joints
		posePositions[i] = randi() % 360

func dogPoser():
	for i in range(12):
		poseNode = get_node(poseArray[i])
		if poseNode.rotation_degrees < posePositions[i]:
			poseNode.rotation_degrees += .2
		if poseNode.rotation_degrees > 360:
			poseNode.rotation_degrees = 0

func dogGrader():
	for i in range(12):
		selectNode = get_node(partArray[i])
		poseNode = get_node(poseArray[i])
		jointScores[i] =  angleDist(int(poseNode.rotation_degrees), int(selectNode.rotation_degrees))
		scoreTotal += jointScores[i]
		print(i , ": " , jointScores[i])
	print(scoreTotal)
	resetGrade()

func resetGrade():
	for i in range(12):
		jointScores[i] = 0
		scoreTotal = 0
	print("Score Reset")

func angleDist(angle1, angle2):
	var diff = abs(angle1 - angle2) % 360
	if diff > 180:
		diff = 360 - diff
	return diff

## Todo
# - clock
# - randomized dog colors
# - leaderboard
