extends Shape
class_name Point

@export var position: Vector2 = Vector2.ZERO
func _init(_position_or_x, _y: float = NAN) -> void:
	if !is_nan(_y): position = Vector2(_position_or_x, _y)
	else: position = _position_or_x
