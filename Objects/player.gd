extends CharacterBody2D

const SPEED = 150
const JUMP_VELOCITY = -400.0

@onready var anim = $AnimatedSprite2D
@onready var part_dust = $ParticlesDust
@onready var anim_player = $AnimationPlayer

@onready var sfx_explosion = $SfxExplosion
@onready var sfx_jump = $SfxJump

@onready var cam = get_tree().get_first_node_in_group("camera")

@export var current_level: String

var on_ground := false

var follower = self
var fruits: int = 0

signal interact

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	anim.play("Idle")
	add_to_group("player")

func _process(delta):
	handle_input()

func handle_input():
	if Input.is_action_just_pressed("interact"):
		emit_signal("interact", self)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		on_ground=false
		velocity.y += gravity * delta
	else:
		if on_ground==false:
			sfx_explosion.play()
		on_ground=true
		
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		part_dust.restart()
		part_dust.emitting = true
		sfx_jump.play()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	animate()

	move_and_slide()

func remove_follower() -> Node2D:
	#removes a follower and returns the removed follower, null if none is removed 
	var out = null 
	if follower == self: return null #could not remove follower, no followers exist
	var re = follower.remove_follower()
	if re == null: 
		out = follower
		follower = self
	else: out = re
	
	out.leader = out
	if out.is_in_group("fruit"): 
		fruits -= 1
		out.destroy()
	return out

func get_follower(_follower) -> Node2D:
	if _follower.is_in_group("fruit"): fruits += 1
	
	if follower == self: 
		follower = _follower
		return self
	else: return follower.get_follower(_follower)

func animate():
	if velocity.x != 0:
		anim.play("Run")
		if velocity.x > 0: anim.flip_h = false
		if velocity.x < 0: anim.flip_h = true
	else: anim.play("Idle")
	

	if !is_on_floor():
		if velocity.y < 0: anim.play("Jump")
		elif velocity.y > 0: anim.play("Fall")

func die():
	await(cam.close())
	get_tree().change_scene_to_file(current_level)
