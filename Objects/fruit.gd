extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

@export var speed: float = 0.05
@export var follow_distance: float = 30

var leader: Node2D
var follower: Node2D = self
var following: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("fruit")
	sprite.play("default")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if following: follow()
	
func follow() -> void:
	position.y = lerp(position.y, leader.position.y, speed)
	if position.distance_to(leader.global_position) < follow_distance: return
	position.x = lerp(position.x, leader.position.x, speed)
	
func remove_follower() -> Node2D:
	#removes a follower and returns the removed follower, null if none is removed 
	var out = null 
	if follower == self: return null #could not remove follower, no followers exist
	var re = follower.remove_follower()
	if re == null: 
		out = follower
		follower = self
		return out
	else:
		return re

func get_follower(_follower) -> Node2D:
	if follower == self: 
		follower = _follower
		return self
	else: return follower.get_follower(_follower)
	

func destroy() -> void:
	anim.play("destroy")
	await anim.animation_finished
	queue_free()
	

func _on_body_entered(body) -> void:
	if following: return
	if body.is_in_group("player") or body.is_in_group("fruit"):
		following = true
		leader = body.get_follower(self)
		$AudioStreamPlayer2D.play()
