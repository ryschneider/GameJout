extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

const TOP_SPEED = 200
const ACC_TIME = 0.1 # seconds
const DEC_TIME = 0.2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var Hook = get_node("/root/Node2D/Hook")

func grapple():
	Hook.direction = (get_global_mouse_position() - position).normalized()
	Hook.position = position
	Hook.show()

func ungrapple():
	Hook.destroy()

var moveVel = Vector2()

func _physics_process(dt):
	if not is_on_floor():
		velocity.y += gravity * dt

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y += JUMP_VELOCITY
		elif Hook.isHooked:
			velocity.y += JUMP_VELOCITY
			ungrapple()

	var speed = SPEED
	if Input.is_action_pressed("sprint"):
		speed *= 2

#	if Input.is_action_pressed("move_right"):
		

	var dir = Input.get_axis("move_left", "move_right")
	if dir:
		moveVel.x = speed * dir

	if Input.is_action_just_pressed("grapple"):
		grapple()
	elif Input.is_action_just_released("grapple"):
		ungrapple()

	velocity = Hook.apply(velocity)
	moveVel = Hook.apply(moveVel)
	
	velocity += moveVel
	move_and_slide()
	velocity -= moveVel
	
	for i in get_slide_collision_count():
		velocity.x = lerp(velocity.x, 0.0, 0.1)
		moveVel = lerp(moveVel, Vector2(), 0.1)
