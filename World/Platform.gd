extends Node2D

const Toaster = preload("res://World/Toaster.tscn")
const ToasterSprite = preload("res://World/TripleToaster.png")

const TOASTER_SPRITE_WIDTH = 64
const AVAILABLE_SLOTS = 8

export(int) var GAP_SIZE = 2

signal hit
signal passed

#export(int) onready var available_slots = int(get_viewport().size.x) / TOASTER_SPRITE_WIDTH

var hit: bool = false
var passed: bool = false

func _ready():
	generate_platform()

func generate_platform():
	var left_platform_size = (randi() % (AVAILABLE_SLOTS - GAP_SIZE + 1))
	var right_platform_size = AVAILABLE_SLOTS - left_platform_size - GAP_SIZE
	
	var toasters = get_node("Toasters").get_children()
	for n in AVAILABLE_SLOTS:
		var toaster: Area2D = toasters[n]
		
		if n < left_platform_size || n >= left_platform_size + GAP_SIZE:
			toaster.connect("body_entered", self, "toaster_touch")
		else:
			toaster.connect("body_entered", self, "toaster_point_collect")
			var toasterSprite: Sprite = toaster.get_node("Sprite")
			toasterSprite.visible = false

func toaster_touch(_body: Node):
	if !hit:
		hit = true
		emit_signal("hit")

func toaster_point_collect(_body: Node):
	if !passed:
		passed = true
		emit_signal("passed")

