extends Node


@onready var timer := $Label as Label
@onready var animation := $Animation as AnimatedSprite2D

var time : int
var minute : String
var second : String


func _ready():
	time = 0
	timer.text = "00:00"
	animation.play()


func _on_tick_timeout():
	time += 1

	if time - (floor(time / 60)) * 60 < 10:
		second = "0" + str(time - (floor(time / 60)) * 60)
	
	else:
		second = str(time - (floor(time / 60)) * 60)
		@warning_ignore("integer_division")
	
	if floor(time / 60) < 10:
		minute = "0" + str(floor(time / 60))

	else:
		minute = str(floor(time / 60))
		@warning_ignore("integer_division")

	timer.text = minute + ":" + second
	