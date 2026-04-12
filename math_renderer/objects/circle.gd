extends Shape
class_name Circle

@export var radius: float = 1.0
@export var position: Vector2 = Vector2.ZERO

func _init(_radius: float = 1.0, _position: Vector2 = Vector2.ZERO) -> void:
	radius = _radius
	position = _position

func has_point(p: Vector2):
	return is_equal_approx(p.distance_squared_to(position), radius*radius)

func _to_string() -> String:
	return "(x %s %.3f)² + (y %s %.3f)² = %.3f" % [
		"+" if -position.x > 0 else "-",
		abs(position.x),
		"+" if -position.y > 0 else "-",
		abs(position.y),
		radius * radius
	]
