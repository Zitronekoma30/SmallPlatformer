extends Area2D

@onready var mark = $Marker2D
@onready var anim = $AnimationPlayer

@onready var cam = get_tree().get_first_node_in_group("camera")
@onready var sprite = $AnimatedSprite2D
#@export var next_level: PackedScene

@export var fruit_needs: int = 3
var fruit_has: int = 0

var full: bool = false


func set_shining(shining: bool) -> void:
	sprite.material.set_shader_parameter("effect_on", shining)

func unlock():
	set_shining(true)

func finish_level():
	set_shining(false)
	await(cam.close())
	get_tree().change_scene_to_file("res://Levels/test_level.tscn")
	
func _on_player_interact(player):
	if full: 
		finish_level()
		return
	if player.fruits > 0:
		player.remove_follower()
		fruit_has += 1
		anim.play("Fill")
		if fruit_has >= fruit_needs: 
			unlock()
			full = true

func _on_body_entered(body) -> void:
	if body.is_in_group("player"): body.interact.connect(_on_player_interact)


func _on_body_exited(body) -> void:
	if body.is_in_group("player"): body.interact.disconnect(_on_player_interact)
