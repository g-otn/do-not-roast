extends Node2D

const Platform = preload("res://World/Platform.tscn")

export(int) var DISTANCE = 300
export(int) var BUFFER_EXTRA_SIZE = 4
export(int) var INITIAL_PLATFORMS = 2

signal hit
signal passed

var platform_count = 0

var buffer: Array = [] # Size will be INITIAL_PLATFORMS + BUFFER_EXTRA_SIZE
var passes = 0

func _ready():
	reset()

func create_initial_platforms():
	for n in INITIAL_PLATFORMS:
		push_new_platform()
	pass

func push_new_platform():
	var platform = Platform.instance()
	platform.position.y = -1 * platform_count * DISTANCE
	platform_count += 1
	platform.connect("hit", self, "_on_Platform_hit")
	platform.connect("passed", self, "_on_Platform_passed")
	add_child(platform)
	buffer.push_front(platform)

func pop_first_platform():
	var platform = buffer.pop_back()
	platform.queue_free()

func _on_Platform_hit():
	emit_signal("hit")
	pass

func _on_Platform_passed():
	# Start clearing first buffer platform every platform pass 
	# once player passed through last initial one
	passes += 1
	if passes > BUFFER_EXTRA_SIZE:
		pop_first_platform()
	
	push_new_platform()
	

	emit_signal("passed")

func clear_platforms():
	for platform in buffer:
		platform.queue_free()
	buffer.clear()

func reset():
	randomize()
	platform_count = 0
	passes = 0
	clear_platforms()
	create_initial_platforms()

func _on_Player_reseted():
	reset()

