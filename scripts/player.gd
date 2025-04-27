extends CharacterBody2D
class_name Player

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum States {IDLE, RUNNING, JUMPING, FALLING, GET_HIT, DEATH}

# This variable keeps track of the character's current state.
var current_state: States = States.IDLE
var is_invincible = false
var health = 3
var knockback_dir
var knockback = Vector2.ZERO
var spawn_point = Vector2(92.0, 109.0)
@onready var player_sprite = $AnimatedSprite2D
@onready var heart_bar = get_node("%HeartBar")

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

func take_damage(enemyPos: Vector2, knockback_strength: float) -> void:
	if is_invincible:
		return
	
	knockback_dir = (global_position - enemyPos).normalized()
	knockback = knockback_dir * knockback_strength
	_set_state(States.GET_HIT)
	
	health -= 1
	heart_bar.update_simple(health)
	is_invincible = true
	if health == 0:
		_set_state(States.DEATH)
		return
		
	await get_tree().create_timer(1)
	is_invincible = false	

func update_spawn_point(checkpoint: Vector2):
	spawn_point = checkpoint
	
func respawn_in_checkpoint():
	health = 3
	global_position = spawn_point
	is_invincible = false
	player_sprite.flip_h = false
	_set_state(States.IDLE)

	
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
				velocity.x = move_toward(velocity.x, 0, 10)
			if is_on_floor():
				_set_state(States.IDLE)	
		States.JUMPING:
			velocity.y = JUMP_VELOCITY
			if not is_on_floor():
				_set_state(States.FALLING)
		States.GET_HIT:
			if not is_on_floor():
				velocity.y += gravity * delta
			
			velocity.x = knockback.x * SPEED
			# make sure knockback on the y axis is not too much
			velocity.y = max(-300, -abs(velocity.y * knockback.y))
			knockback = lerp(knockback, Vector2.ZERO, 0.1)
			
			if abs(knockback.x) < 0.1 and abs(knockback.y) < 0.1 :
				if not is_on_floor():
					_set_state(States.FALLING)
				else:
					_set_state(States.IDLE)
		States.DEATH:
			velocity.x = 0
			velocity.y += gravity * delta
			await get_tree().create_timer(1).timeout
			respawn_in_checkpoint()
			
			
# main function call
func _physics_process(delta: float) -> void:
	_update_state(delta)	
	move_and_slide()
	heart_bar.update_simple(health)
