extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum States {IDLE, RUNNING, JUMPING, FALLING, GET_HIT, DEATH}

# This variable keeps track of the character's current state.
var current_state: States = States.IDLE
var is_invincible = false
@onready var player_sprite = $AnimatedSprite2D

func _on_ready() -> void:
	_set_state(States.IDLE)

# Avoid redundancy
func _handle_horizontal_movement(direction: float) -> void:
	if direction:
		velocity.x = direction * SPEED
				
	if velocity.x > 0:
		player_sprite.flip_h = false
	elif velocity.x < 0:
		player_sprite.flip_h = true
		
# Animation player based on current state of the player
func _enter_state() -> void:
	match current_state:
		States.IDLE:
			player_sprite.play("idle")
		States.RUNNING:
			player_sprite.play("run")
		States.JUMPING:
			player_sprite.play("jump")
		States.FALLING:
			player_sprite.play("jump")
		States.GET_HIT:
			player_sprite.play("hit")
		States.DEATH:
			player_sprite.play("death")
			
# Transition to a new state
func _set_state(new_state: States) -> void:
	if current_state == new_state:
		return
		
	current_state = new_state
	_enter_state()
	
# Everything that needs to happen in a state
func _update_state(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	match current_state:
		States.IDLE:
			if !is_on_floor():
				_set_state(States.FALLING)
			elif Input.is_action_just_pressed("jump"):
				_set_state(States.JUMPING)
			elif direction:
				_set_state(States.RUNNING)
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		States.RUNNING:
			if !is_on_floor():
				_set_state(States.FALLING)
			elif Input.is_action_just_pressed("jump"):
				_set_state(States.JUMPING)
			if direction:
				_handle_horizontal_movement(direction)
			else:
				_set_state(States.IDLE)
		States.FALLING:
			velocity.y += gravity * delta
			if direction:
				_handle_horizontal_movement(direction)
			else: 
				velocity.x = move_toward(velocity.x, 0, 5)
			if is_on_floor():
				_set_state(States.IDLE)	
		States.JUMPING:
			velocity.y = JUMP_VELOCITY
			if not is_on_floor():
				_set_state(States.FALLING)
			
				
func _physics_process(delta: float) -> void:
	_update_state(delta)	
	move_and_slide()
