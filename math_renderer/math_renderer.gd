extends Control

var view: Rect2 = Rect2(-5, -5, 10, 10)
var cm: float = 1.0
var cb: float = 0.0


func _process(delta: float) -> void:
	view.size = size / 60
	var dir = Input.get_vector(&"ui_left", &"ui_right", &"ui_down", &"ui_up")
	view.position += delta * dir * 60 * 0.125 * Vector2(1.0, size.x / size.y)
	cm += Input.get_axis(&"test_left", &"test_right") * 60 * delta * 0.25
	cb += Input.get_axis(&"test_down", &"test_up") * 60 * delta * 0.125
	queue_redraw()

func _draw() -> void:
	draw_grid(2)
	draw_axis(Vector2i.RIGHT, 1)
	draw_axis(Vector2i.UP, 1)
	var p = Vector2(sqrt(2)/2,-sqrt(2)/2)#glob(get_global_mouse_position())
	graph_line(cm, cb)
	graph_line(2, 3)
	graph_circle(1, p)
	var i = circle_line_intersects(cm, cb, 1, p)
	var j = circle_line_intersects(2, 3, 1, p)
	var c = line_line_intersects(2, 3, cm, cb)
	graph_points(i)
	graph_points(j)
	graph_points(c)

func graph_points(points: Array[Vector2]) -> void:
	for point: Vector2 in points:
		draw_circle(locv(point), 5, Color.BLACK)
func circle_line_intersects(m: float, b: float, r: float, p: Vector2) -> Array[Vector2]:
	var a = 1 + m*m
	var _b = 2 * (m*b - m*p.y - p.x)
	var c = p.x*p.x + p.y*p.y - r*r + b*b - 2*b*p.y
	var discriminant = _b*_b - 4*a*c
	if is_equal_approx(discriminant, 0.0):
		var x = -_b / (2*a)
		return [Vector2(x, x*m + b)]
	if discriminant < 0.0:
		return []
	var sqrt_discriminant = sqrt(discriminant)
	var x1 = (-_b + sqrt_discriminant) / (2*a)
	var x2 = (-_b - sqrt_discriminant) / (2*a)
	return [
		Vector2(x1, x1*m + b),
		Vector2(x2, x2*m + b)
	]

func line_line_intersects(m1: float, b1: float, m2: float, b2: float) -> Array[Vector2]:
	if is_equal_approx(m1, m2): return []
	var x: float = (b1 - b2) / (m2 - m1)
	return [Vector2(x, x*m1 + b1)]

func graph_circle(r: float, p: Vector2):
	var mx = (size.x / view.size.x)
	var my = (size.y / view.size.y)
	draw_ellipse(locv(p), r * mx, r * my, Color.RED, false)

func graph_line(m: float, b: float):
	var p1 = Vector2(view.position.x, view.position.x * m + b)
	var p2 = Vector2(view.end.x, view.end.x * m + b)
	draw_line(locv(p1), locv(p2),Color.RED)

func draw_grid(steps):
	### TODO: Ts did not work
	pass
		
func draw_axis(axis: Vector2i, steps: int):
	var n = 0.125
	var rang = range(view.position.y, view.end.y + 1, steps) \
	if axis == Vector2i.UP else\
	range(view.position.x, view.end.x + 1, steps)
	
	for c in rang:
		if axis == Vector2i.UP:
			draw_line(loc(-n, c),loc(+n, c),Color.BLACK)
		if axis == Vector2i.RIGHT:
			draw_line(loc(c, -n),loc(c, +n),Color.BLACK)
	
	if axis == Vector2i.UP:
		draw_line(loc(0,view.position.y), loc(0,view.end.y), Color.BLACK)
	if axis == Vector2i.RIGHT:
		draw_line(loc(view.position.x, 0), loc(view.end.x, 0), Color.BLACK)
	
func locx(x) -> float:
	return loc(x, 0).x
func locy(y) -> float:
	return loc(0, y).y

func loc(x, y) -> Vector2:
	var v = Vector2(
		remap(x, view.position.x, view.end.x, 0.0, size.x),
		remap(y, view.position.y, view.end.y, size.y, 0.0)
	)
	return v

func glob(v: Vector2) -> Vector2:
	var nv = Vector2(
		remap(v.x, 0.0, size.x, view.position.x, view.end.x),
		remap(v.y, size.y, 0.0, view.position.y, view.end.y)
	)
	return nv

func locv(v: Vector2) -> Vector2:
	return loc(v.x, v.y)
