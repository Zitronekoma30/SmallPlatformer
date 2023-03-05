extends Camera2D

@onready var anim = $AnimationPlayer

@export var player : CharacterBody2D
@export var speed = 0.1
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("camera")
	anim.play("Open")


func close():
	anim.play("Close")
	return anim.animation_finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	position = lerp(position, player.position, speed)
