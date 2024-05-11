extends CharacterBody2D

@export var player_camera: PackedScene
@export var camera_height = 316
@export var player_sprite: AnimatedSprite2D

@export var movement_speed = 300
@export var gravity = 30
@export var jump_strength = 600
@export var max_jumps = 2

@onready var initial_sprite_scale = player_sprite.scale

var owner_id = 1
var jump_count = 0
var camera_instance
var state = PlayerState.IDLE
var current_interactible = null

enum PlayerState {
	IDLE,
	WALKING,
	JUMP_STARTED,
	JUMPING,
	DOUBLE_JUMPING,
	FALLING
}

# _ready waits until everything is ready
# _enter_tree happens even before
func _enter_tree():
	owner_id = name.to_int()
	set_multiplayer_authority(owner_id)
	
	# If the owner_id is not me
	if owner_id != multiplayer.get_unique_id():
		return
		
	set_up_camera()

func _process(_delta):
	if multiplayer.multiplayer_peer == null:
		return
		
	# If the owner_id is not me
	if owner_id != multiplayer.get_unique_id():
		return
		
	update_camera_pos()

func _physics_process(_delta):
	# If the owner_id is not me
	if owner_id != multiplayer.get_unique_id():
		return
		
	var horizontal_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	velocity.x = horizontal_input * movement_speed
	velocity.y += gravity
	
	if Input.is_action_just_pressed("interact"):
		if current_interactible != null:
			current_interactible.interact.rpc_id(1) #Call the server
			
	handle_movement_state()
		
	move_and_slide()
	
	face_movement_direction(horizontal_input)


func _on_animated_sprite_2d_animation_finished():
	if state == PlayerState.JUMPING:
		player_sprite.play("jump")

func set_up_camera():
	camera_instance = player_camera.instantiate()
	camera_instance.global_position.y = camera_height
	get_tree().current_scene.add_child.call_deferred(camera_instance)
	
func update_camera_pos():
	camera_instance.global_position.x = global_position.x

func face_movement_direction(horizontal_input):
	if not is_zero_approx(horizontal_input):
		if horizontal_input < 0:
			player_sprite.scale = Vector2(-initial_sprite_scale.x, initial_sprite_scale.y)
		else:
			player_sprite.scale = initial_sprite_scale
			
func handle_movement_state():
	# Decide state
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state = PlayerState.JUMP_STARTED
	elif is_zero_approx(velocity.x) and is_on_floor():
		state = PlayerState.IDLE
	elif is_on_floor() and not is_zero_approx(velocity.x):
		state = PlayerState.WALKING
	else:
		state = PlayerState.JUMPING
	
	if velocity.y > 0.0 and not is_on_floor():
		if Input.is_action_just_pressed("jump"):
			state = PlayerState.DOUBLE_JUMPING
		else:
			state = PlayerState.FALLING
	
	# Process state
	match state:
		PlayerState.IDLE:
			player_sprite.play("idle")
			jump_count = 0
		PlayerState.WALKING:
			player_sprite.play("walk")
			jump_count = 0
		PlayerState.JUMP_STARTED:
			player_sprite.play("jump_start")		
			jump_count += 1
			velocity.y = -jump_strength
		PlayerState.JUMPING:
			pass
		PlayerState.DOUBLE_JUMPING:
			player_sprite.play("double_jump_start")
			jump_count += 1
			if jump_count <= max_jumps:
				velocity.y = -jump_strength
		PlayerState.FALLING:
			player_sprite.play("fall")
		
	# Jump cancelling
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y = 0.0

	

func _on_interaction_handler_area_entered(area):
	current_interactible = area


func _on_interaction_handler_area_exited(area):
	if current_interactible == area:
		current_interactible = null
