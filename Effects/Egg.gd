extends KinematicBody2D

export(int) var GRAVITY = 1
export(int) var DURATION = 3
export(int) var FORCE = 12
export(Vector2) var move_vector: Vector2 = Vector2.ZERO

onready var timer = $Timer

func _ready():
	timer.start(DURATION)

func _physics_process(delta):
	move_and_collide(move_vector * FORCE)

func _on_Timer_timeout():
	queue_free()
