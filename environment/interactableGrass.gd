extends Area2D

func _ready():
	#randomize whether this grass will appear
	randomize()
	var appear = rand_range(0.0, 3.0)
	if (appear < 0.5):
		queue_free()
	
	#randomize the scale of the grass
	randomize()
	var randScale = rand_range(.3, 1.2)
	set_scale(Vector2(randScale,randScale))
	
	#randomize whether the grass will be flipped
	randomize()
	var flipped = rand_range(0.0, 1.0)
	if (flipped < 0.5):
		$"AnimatedSprite".flip_h = true

func _on_interactableGrass_body_entered(body):
	$"AnimatedSprite".playing = true;
	$"AnimatedSprite".frame = 0;
