extends Camera2D

const FIRE_SPRITE_HEIGHT = 64

export(int) var INITIAL_LIMIT_BOTTOM = 720
export(int) var OFFSET_FROM_PLAYER = 360

onready var grill = $Node/Grill

func reset():
	limit_smoothed = false
	smoothing_enabled = false
	limit_bottom = INITIAL_LIMIT_BOTTOM

func _physics_process(delta):
	var origin = -get_viewport_transform().origin
	var camera_height = get_viewport().size.y
	grill.position.y = origin.y + camera_height - FIRE_SPRITE_HEIGHT

func _on_Player_jumped():
	limit_smoothed = true
	smoothing_enabled = true
	var viewportTransform: Transform = get_viewport_transform()
	var camera_height = get_viewport().size.y
	limit_bottom = min(INITIAL_LIMIT_BOTTOM, -viewportTransform.origin.y + camera_height)

func _on_Player_reseted():
	reset()
