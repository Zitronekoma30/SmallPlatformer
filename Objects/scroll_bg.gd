extends Node2D

@onready var spr1 = $Sprite
@onready var spr2 = $Sprite2
@onready var mark = $Marker2D

@onready var start_h : int = spr2.position.y

@export var speed: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spr1.position.y += speed
	spr2.position.y += speed
	
	if spr1.position.y > mark.position.y:
		spr1.position.y = start_h + 1 
	
	if spr2.position.y > mark.position.y:
		spr2.position.y = start_h + 1
