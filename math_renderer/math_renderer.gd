extends Control

var view: Rect2 = Rect2(-5 * 2, -2.5 * 2, 10 * 2, 5 * 2)
var cm: float = 0.0
var cb: float = 0.0


func _process(delta: float) -> void:
	var dir = Input.get_vector(&"ui_left", &"ui_right", &"ui_down", &"ui_up")
	view.position += delta * dir * 60 * Vector2(view.size.x / size.x, view.size.y / size.y) * 5
	queue_redraw()

func _draw() -> void:
	draw_grid(Vector2i.UP, 1)
	draw_grid(Vector2i.RIGHT, 1)
	draw_axis(Vector2i.UP, 1)
	draw_axis(Vector2i.RIGHT, 1)
	
	var intersections_drawn: Dictionary[int, bool] = {}
	for node in get_children():
		if node is not Shape: continue
		if node is Circle: graph_circle(node.radius, node.position, node.color)
		if node is Line: graph_line(node.m, node.b, node.color)
		
	for node in get_children():
		if node is not Shape: continue
		if node is Point:
			graph_points([node.position], node.color)
			continue
		for sibling in get_children():
			if intersections_drawn.has(hash(sibling) + hash(node)):
				continue
			if sibling == node: continue
			if node is not Shape: continue
			var p: Array[Vector2]
			if node is Circle and sibling is Line:
				p = circle_line_intersects(sibling.m, sibling.b, node.radius, node.position)
			if sibling is Circle and node is Line:
				p = circle_line_intersects(node.m, node.b, sibling.radius, sibling.position)
			if node is Line and sibling is Line:
				p = line_line_intersects(node.m, node.b, sibling.m, sibling.b)
			intersections_drawn[hash(sibling) + hash(node)] = true
			graph_points(p)

func graph_points(points: Array[Vector2], color: Color = Color.BLACK) -> void:
	for point: Vector2 in points:
		draw_circle(locv(point), 5, color,  true, -1.0, true)

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

func graph_circle(r: float, p: Vector2, color):
	var mx = (size.x / view.size.x)
	var my = (size.y / view.size.y)
	draw_ellipse(locv(p), r * mx, r * my, color, false, 1, true)

func graph_line(m: float, b: float, color: Color):
	var p1 = loc(view.position.x, view.position.x * m + b)
	var p2 = loc(view.end.x, view.end.x * m + b)
	draw_line(p1, p2, color, 1, true)

func draw_grid(axis: Vector2i, steps: float):
	if axis == Vector2i.RIGHT:
		var x = view.position.x - fmod(view.position.x, steps)
		while (x < view.end.x):
			draw_line(Vector2(locx(x), 0), Vector2(locx(x), size.y), Color.GRAY)
			x += steps
	if axis == Vector2i.UP:
		var y = view.position.y - fmod(view.position.y, steps)
		while (y < view.end.y):
			draw_line(Vector2(0, locy(y)), Vector2(size.x, locy(y)), Color.GRAY)
			y += steps
	
func draw_axis(axis: Vector2i, steps: int):
	var n = 0.125
	
	if axis == Vector2i.UP:
		draw_line(loc(0,view.position.y), loc(0,view.end.y), Color.BLACK)
		
		var y = view.position.y - fmod(view.position.y, steps)
		while (y < view.end.y):
			draw_line(loc(-n, y), loc(+n, y), Color.BLACK)
			y += steps
	if axis == Vector2i.RIGHT:
		draw_line(loc(view.position.x, 0), loc(view.end.x, 0), Color.BLACK)
		
		var x = view.position.x - fmod(view.position.x, steps)
		while (x < view.end.x):
			draw_line(loc(x, -n), loc(x, +n), Color.BLACK)
			x += steps
	
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
