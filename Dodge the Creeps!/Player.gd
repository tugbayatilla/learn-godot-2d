extends Area2D
signal hit

# export: set the value in inspector
export var speed = 400 # pixel/sec
var screen_size



# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var velocity = Vector2.ZERO
	
	# find direction/velocity
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	# normalized because diagonal movement is bigger than 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	# clamp is like Math.Max
	# prevent the player will leave the screen
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	if velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
		
		


func _on_Player_body_entered(_body):
	hide()
	emit_signal("hit")
	# We need to disable the player's collision so that we don't trigger the hit signal more than once.	
	$CollisionShape2D.set_deferred("disabled", true)	
	# Disabling the area's collision shape can cause an error 
	# if it happens in the middle of the engine's collision processing. 
	# Using set_deferred() tells Godot to wait to disable the shape until it's safe to do so.
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
	
	
	
