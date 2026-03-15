extends Control

var view: Rect2 = Rect2(-5, -5, 10, 10)
var m: float = 1.0
var b: float = 0.0


func _process(delta: float) -> void:
	var dir = Input.get_vector(&"ui_left", &"ui_right", &"ui_down", &"ui_up")
	view.position += delta * dir * 60 * 0.125 * Vector2(1.0, size.x / size.y)
	m += Input.get_axis(&"test_left", &"test_right") * 60 * delta * 0.25
	b += Input.get_axis(&"test_down", &"test_up") * 60 * delta * 0.125
	queue_redraw()

func _draw() -> void:
	draw_grid(1)
	draw_axis(Vector2i.RIGHT, 1)
	draw_axis(Vector2i.UP, 1)
	draw_circle(
		locv(snapped(glob(get_global_mouse_position()), Vector2.ONE))
		, 5, Color.RED)

	var p1 = Vector2(view.position.x, view.position.x * m + b)
	var p2 = Vector2(view.end.x, view.end.x * m + b)
	draw_line(locv(p1), locv(p2),Color.RED)

func draw_grid(steps):
	for x in range(view.position.x, view.end.x + 1, steps):
		draw_line(
			loc(x, view.position.y),
			loc(x, view.end.y),
			Color.LIGHT_GRAY
		)
	for y in range(view.position.y, view.end.y + 1, steps):
		draw_line(
			loc(view.position.x, y),
			loc(view.end.x, y),
			Color.LIGHT_GRAY
		)
		
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
