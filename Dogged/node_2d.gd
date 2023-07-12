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
var colorArray = [0,0,0]
var colorHighlightArray = [0,0,0]
var contestantNum = 1
var timerSecs = 90

# 0 for intro, 1 for randomizer, 2 for posing, 3 for player control, 4 for score
var gameState = 0

func _ready():
    colorRandomizer()
    $TextContainer/LabelInfo.text = "Press ENTER/CONFIRM to begin!"

func _process(delta):
    
    if gameState == 0:
        if Input.is_action_just_pressed("key_confirm"):
            gameState = 1
    
    if gameState == 1:
        $TextContainer/LabelInfo.text = ":^)"
        resetDogs()
        randomizer()
    
    if gameState == 2:
        $TextContainer/LabelInfo.text = "WATCH THE EXAMPLE DOG"
        $TextContainer/LabelTime.text = "←←←←"
        dogPoser()
    
    if gameState == 3:
        $TextContainer/LabelInfo.text = "now do that! :^)"
        $TextContainer/LabelTime.text = "timer"
        playerControl()
        if Input.is_action_just_pressed("key_confirm"):
            gameState = 4
            
    if gameState == 4:
        dogGrader()
        $TextContainer/LabelInfo.text = String("Contestant %d's score:" % contestantNum)
        $TextContainer/LabelTime.text = String("%d" % scoreTotal)
        if Input.is_action_just_pressed("key_confirm"):
            resetGrade()
            gameState = 0
    
func timerSet():
    # Reset the timer to 0
    pass

func timerStart():
    # Start timer, update screen
    pass

func randomizer():
    poseRandomizer()
    gameState = 2

func poseRandomizer():
    randomize()
    
    for i in range(12):
        poseNode = get_node(poseArray[i])
        # Randomly rotates the dog's joints
        posePositions[i] = randi() % 360

func colorRandomizer():
    randomize()
    
    for p in range(3):
        colorArray[p] = randi() % 15
    
    for i in range(12):
        # Colors pose dog a ? color? ?
        poseSprite = get_node(poseArray[i] + "/Sprite2D")
        poseSprite.modulate = Color(colorArray[0],colorArray[1],colorArray[2])
    
    for c in range(3):
        colorArray[c] = randi() % 15
        
    for i in range(12):
        # Colors player dog a ? color? ?
        poseNode = get_node(partArray[i] + "/Sprite2D")
        poseNode.modulate = Color(colorArray[0],colorArray[1],colorArray[2])
        
    for i in range(3):
        colorHighlightArray[i] = colorArray[i] + 3

func dogPoser():
    var poseSet = 0
    
    for i in range(12):
        poseNode = get_node(poseArray[i])
        if poseNode.rotation_degrees < posePositions[i]:
            if Input.is_action_pressed("key_up"):
                poseNode.rotation_degrees += 1
            else:
                poseNode.rotation_degrees += .2
        if poseNode.rotation_degrees > 360:
            poseNode.rotation_degrees = 0
        if poseNode.rotation_degrees >= posePositions[i]:
            poseSet += 1
        if poseSet == 12:
            gameState = 3

func dogGrader():
    for i in range(12):
        selectNode = get_node(partArray[i])
        poseNode = get_node(poseArray[i])
        jointScores[i] =  angleDist(int(poseNode.rotation_degrees), int(selectNode.rotation_degrees))
        scoreTotal += jointScores[i]

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

func resetDogs():
    for i in range(12):
            selectNode = get_node(partArray[i])
            poseNode = get_node(poseArray[i])
            selectNode.rotation_degrees = 0
            poseNode.rotation_degrees = 0

func poseExample():
    poseRandomizer()
    dogPoser()

func playerControl():
    
    # Handle input for part rotation
    if selectNode != null and selectSprite != null:
        if Input.is_action_pressed("key_right"):
            selectNode.rotation_degrees += 1
        if Input.is_action_pressed("key_left"):
            selectNode.rotation_degrees -= 1
    else:
        selectNode = get_node(partArray[partIndex])
        selectSprite = get_node(partArray[partIndex] + "/Sprite2D")
        selectSprite.modulate = Color(colorHighlightArray[0],colorHighlightArray[1],colorHighlightArray[2])
    
    # Handle input for part selection
    
    
    if Input.is_action_just_pressed("key_up"):
        selectSprite.modulate = Color(colorArray[0],colorArray[1],colorArray[2])
        if partIndex == 11:
            partIndex = 0
        else:
            partIndex += 1
        selectNode = get_node(partArray[partIndex])
        selectSprite = get_node(partArray[partIndex] + "/Sprite2D")
        selectSprite.modulate = Color(colorHighlightArray[0],colorHighlightArray[1],colorHighlightArray[2])
    if Input.is_action_just_pressed("key_down"):
        selectSprite.modulate = Color(colorArray[0],colorArray[1],colorArray[2])
        if partIndex == 0:
            partIndex = 11
        else:
            partIndex -= 1
        selectNode = get_node(partArray[partIndex])
        selectSprite = get_node(partArray[partIndex] + "/Sprite2D")
        selectSprite.modulate = Color(colorHighlightArray[0],colorHighlightArray[1],colorHighlightArray[2])

## Todo
# - clock
# - leaderboard
