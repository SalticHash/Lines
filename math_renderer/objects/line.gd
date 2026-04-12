extends Shape
class_name Line

@export var m: float = 1.0
@export var b: float = 0.0

func _init(_m: float = 1.0, _b: float = 0.0) -> void:
	m = _m
	b = _b


func set_from_points(one: Vector2, two: Vector2) -> void:
	m = (two.y - one.y) / (two.x - one.x)
	b = one.y - (m * one.x)

func get_point_at_x(x: float) -> Vector2:
	return Vector2(x, m*x + b)

func get_point_at_y(y: float) -> Vector2:
	return Vector2((y - b) / m, y)

func has_point(p: Vector2) -> bool:
	return get_point_at_x(p.x) == p

func _to_string() -> String:
	return "y = %.3fx + %.3f" % [m, b]
