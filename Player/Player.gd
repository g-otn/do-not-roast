extends KinematicBody2D


const Egg = preload("res://Effects/Egg.tscn")
const DieAudioStream = preload("res://Music and Sounds/Die.wav")
const JumpAudioStream = preload("res://Music and Sounds/Jump.wav")
const ResetAudioStream = preload("res://Music and Sounds/Reset.wav")

export(int) var ROTATION_STEP = 2
export(int) var JUMP_FORCE = 600
export(int) var GRAVITY = 1500
export(Vector2) var INITIAL_GLOBAL_POSITION = Vector2(256, 550)
export(bool) var IMMORTAL = false

enum State {
	PAUSED,
	MOVE,
	DEAD
}

signal jumped
signal reseted

onready var animatedSprite = $AnimatedSprite
onready var audioStreamPlayer = $AudioStreamPlayer
onready var collisionShape2D = $CollisionShape2D

var state = State.PAUSED
var move_vector = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func reset():
	move_vector = Vector2.ZERO
	state = State.PAUSED
	rotation_degrees = rand_range(-15, 15)
	update_sprite()
	clear_eggs()
	global_position = INITIAL_GLOBAL_POSITION
	play_audio_stream(ResetAudioStream)

func _physics_process(delta: float):
	match state:
		State.PAUSED:
			paused_state()
		
		State.MOVE:
			move_state(delta)
	
		State.DEAD:
			dead_state()

func paused_state():
	apply_rotation()
	
	if Input.is_action_just_pressed("jump"):
		collisionShape2D.disabled = false
		jump()
		move()
		state = State.MOVE
	

func move_state(delta: float):
	apply_rotation()
	
	# Apply gravity force
	move_vector.y += delta * GRAVITY

	if Input.is_action_just_pressed("jump"):
		jump()
	
	update_sprite()
	
	move()

func dead_state():
	if Input.is_action_just_pressed("jump"):
		collisionShape2D.disabled = true
		emit_signal("reseted")
		reset()

func update_sprite():
	if move_vector.y < 0:
		animatedSprite.animation = "Idle"
	else:
		animatedSprite.animation = "Flapping" # Flapping while falling

	if rotation_degrees < 0:
		animatedSprite.flip_h = false
	else:
		animatedSprite.flip_h = true

func apply_rotation():
	var rotation_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if rotation_direction != 0:
		rotation_degrees += rotation_direction * ROTATION_STEP

func jump():
	play_audio_stream(JumpAudioStream)
	
	create_egg()
	
	# Normalized vector pointing to the top side of the player
	var jump_vector = Vector2(0, -1).rotated(deg2rad(rotation_degrees))
	move_vector = jump_vector * JUMP_FORCE
	emit_signal("jumped")

func move():
	move_vector = move_and_slide(move_vector)

func die():
	if IMMORTAL:
		return
	play_audio_stream(DieAudioStream)
	move_vector = Vector2.ZERO
	rotation_degrees = 0
	animatedSprite.animation = "Dead"
	state = State.DEAD

func create_egg():
	var egg = Egg.instance()
	egg.global_position = global_position
	egg.move_vector = Vector2(0, 1).rotated(deg2rad(rotation_degrees))
	egg.get_node("Sprite").rotation_degrees = rotation_degrees
	get_node("Eggs").add_child(egg)

func clear_eggs():
	# Clear children nodes
	for n in get_node("Eggs").get_children():
		remove_child(n)
		n.queue_free()

func play_audio_stream(audioStream: AudioStream):
	audioStreamPlayer.stream = audioStream
	audioStreamPlayer.play()

func _on_Grill_body_entered(_body: Node):
	die()

func _on_Platforms_hit():
	die()
