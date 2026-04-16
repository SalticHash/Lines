extends Node

@onready var parent: Button = get_parent()
func _ready() -> void:
	parent.pivot_offset_ratio = Vector2.ONE / 2.0
	# Disable press
	#parent.pressed.connect(pressed)
var is_pressed = false
func _process(_delta: float) -> void:
	var tween = create_tween()
	var value = parent.scale
	if is_pressed:
		is_pressed = false
		value = Vector2.ONE * 0.85
	if parent.is_hovered():
		tween.tween_property(parent, "scale", Vector2.ONE * 0.95,0.25).from(value)
	else:
		tween.tween_property(parent, "scale", Vector2.ONE, 0.25)

func pressed(): is_pressed = true
