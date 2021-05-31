extends Viewport

#Specify Model
export(String) var model 

#Constants to manipulate Background
const LENGTH = 6000 #How many pixels until the level end. This is used as a ratio with player position and sensitivity to determine some kind of rotation angle.
const ROTATION_SENSITIVITY = 0.075 #Rotation speed
const ROTATION_SNAP = 1.75 #Rotation snap
const TRANSLATION_SENSITIVITY = 0.16 #Translation speed
const TRANSLATION_SNAP = 0.01 #Translation snap

#Private Variables
var Previous_Camera_Position = 0 #Previous 2D_Camera position
var Delta = 0 #2D_Camera distance traveled since last frame
var Rotation_Distance_Accumulator = 0 #Rotation mode distance traveled
var Translation_Distance_Accumulator = 0 #Translation mode distance traveled

func _ready():
	add_to_group("3D_Object_Handler")
	get_tree().call_group("3D_Model_Container", "load_Model", model)
	
func _process(_delta):
	#Set Render Texture
	get_tree().call_group("Render_Target", "setRenderTexture", self.get_texture())
	#Update Accumulators
	var Camera_Position = $"/root/Global".camera.get_camera_position().x
	Delta = Camera_Position - Previous_Camera_Position
	Previous_Camera_Position = Camera_Position 

#Set Transparancy
func set_Transparent_Background():
	set_transparent_background(true)

#Rotate Model to Player Position
func rotate_Background():
	#Variables
	Rotation_Distance_Accumulator += Delta
	var Rotation = $"3D_World/3D_Camera_Container".rotation_degrees
	#Transformation 
	Rotation.y = (Rotation_Distance_Accumulator / LENGTH) * ROTATION_SENSITIVITY * 360 #Rotate model in degrees based on player's distance traveled from 0 pixels to LENGTH pixels.
	Rotation.y -= fmod(Rotation.y, ROTATION_SNAP) #Rotation Snap
	$"3D_World/3D_Camera_Container".rotation_degrees = Rotation #Set rotation

#Translate Camera to Player Position
func translate_Background():
	#Variables
	Translation_Distance_Accumulator += Delta
	var ModelPositionX = $"3D_World/3D_Model_Container".translation.x
	#Transformation
	ModelPositionX = (Translation_Distance_Accumulator / LENGTH) * TRANSLATION_SENSITIVITY #Translate model based on player's distance traveled.
	ModelPositionX -= fmod(ModelPositionX, TRANSLATION_SNAP)
	$"3D_World/3D_Model_Container".translation.x = ModelPositionX #Set Translation
