extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
func _draw() -> void:
	draw_grid(25)
	draw_axis(Vector2i.RIGHT, 25)
	draw_axis(Vector2i.UP, 25)
	draw_line(loc(0,0),loc(100,100),Color.RED)

func draw_grid(steps):
	for x in range(steps):
		draw_line(
			loc((x + 0.5) * (100.0 / steps), 0),
			loc((x + 0.5) * (100.0 / steps), 100),
			Color.LIGHT_GRAY
		)
	for y in range(steps):
		draw_line(
			loc(0, (y + 0.5) * (100.0 / steps)),
			loc(100, (y + 0.5) * (100.0 / steps)),
			Color.LIGHT_GRAY
		)
func draw_axis(axis: Vector2i, steps: int):
	var n = 0.5
	for c in range(steps):
		if axis == Vector2i.UP:
			draw_line(
				loc(50 - n, (c + 0.5) * (100.0 / steps)),
				loc(50 + n, (c + 0.5) * (100.0 / steps)),
				Color.BLACK
			)
		if axis == Vector2i.RIGHT:
			draw_line(
				loc((c + 0.5) * (100.0 / steps), 50 - n),
				loc((c + 0.5) * (100.0 / steps), 50 + n),
				Color.BLACK
			)
	
	if axis == Vector2i.UP:
		draw_line(loc(50,0), loc(50,100), Color.BLACK)
	if axis == Vector2i.RIGHT:
		draw_line(loc(0,50), loc(100, 50), Color.BLACK)
	
func locx(x) -> float:
	return loc(x, 0).x
func locy(y) -> float:
	return loc(0, y).y

func loc(x, y) -> Vector2:
	var v = Vector2(x,y)
	return v * size / 100
func locv(v: Vector2) -> Vector2:
	return v * size / 100
