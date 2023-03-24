extends Area2D

@export var destination: Marker2D

@onready var sprite := $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.rotation += 0.1

func teleport(player: CharacterBody2D) -> void:
	player.global_position = destination.global_position

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): body.interact.connect(teleport)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): body.interact.disconnect(teleport)