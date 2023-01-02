extends Control

const Digit = preload("res://UI/Digit.tscn")

const DIGIT_SPRITE_WIDTH = 64

var score = 0

func _ready():
	reset()

func reset():
	score = 0 # initial score
	set_score(score)
	pass

func set_score(score: int):
	# Clear children nodes
	for n in get_children():
		remove_child(n)
		n.queue_free()
	
	var digits = str(score).length()
	var score_digits = str(score)

	for n in digits:
		var digitSprite: Sprite = Digit.instance()
		var digit_value = score_digits[n]
		digitSprite.frame = int(digit_value)
		digitSprite.position.x = n * DIGIT_SPRITE_WIDTH + DIGIT_SPRITE_WIDTH / 2
		add_child(digitSprite)


func _on_Platforms_passed():
	score += 1
	set_score(score)

func _on_Player_reseted():
	reset()
