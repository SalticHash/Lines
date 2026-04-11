extends Control

enum LineLineProblem {
	PARALLEL,
	PERPENDICULAR,
	SECANT
}
enum CircleLineProblem {
	SECANT,
	TANGENT,
	EXTERIOR
}
enum ProblemType {
	LineLine,
	CircleLine,
}

func rand_range(from: float, to: float, step: float) -> float:
	return snappedf(randf_range(from, to), step)

func half_n_half(from1: float, to1: float, from2: float, to2: float, step: float) -> float:
	if rand_range(from1, to2, step) <= to1:
		return rand_range(from1, to1, step)
	else:
		return rand_range(from2, to2, step)

func _ready() -> void:
	var render = %MathRenderer
	var probType: ProblemType = ProblemType.values().pick_random()
	if probType == ProblemType.CircleLine:
		var variation = CircleLineProblem.values().pick_random()
		%Title.text = ProblemType.find_key(probType)
		%Desc.text = CircleLineProblem.find_key(variation)
		var r = rand_range(0.5, 2.5, 0.25)
		var pos = Vector2(
			rand_range(render.view.position.x + r, render.view.end.x - r, 0.5),
			rand_range(render.view.position.y + r, render.view.end.y - r, 0.5)
		)
		var circle = Circle.new(
			r,
			pos
		)
		var line = Line.new()
		var distance = 0.0
		var angle = pos.angle_to_point(Vector2.ZERO)
		if abs(tan(angle)) > TAU: angle = PI/3.0
		render.add_child(circle)
		render.add_child(line)
		match variation:
			CircleLineProblem.EXTERIOR: distance = rand_range(circle.radius + 0.25, 3.0, 0.25)
			CircleLineProblem.SECANT: distance = rand_range(0.0, circle.radius - 0.25, 0.25)
			CircleLineProblem.TANGENT: distance = circle.radius
		line.m = tan(angle)
		var offset = circle.position + distance * Vector2(cos(angle + PI/2.0), sin(angle + PI/2.0))
		line.b = line.m * -offset.x + offset.y
	if probType == ProblemType.LineLine:
		var variation = LineLineProblem.values().pick_random()
		%Title.text = ProblemType.find_key(probType)
		%Desc.text = LineLineProblem.find_key(variation)
		var line1 = Line.new()
		
		var vertical = randi_range(0, 1)
		if vertical:
			var top_point = rand_range(render.view.position.x, render.view.end.x, 0.5)
			var bottom_point = half_n_half(
				render.view.position.x, top_point - 0.5,
				top_point + 0.5, render.view.end.x, 0.5
			)
			line1.set_from_points(
				Vector2(top_point, render.view.position.y),
				Vector2(bottom_point, render.view.end.y),
			)
		else:
			var left_point = rand_range(render.view.position.y, render.view.end.y, 0.5)
			var right_point = half_n_half(
				render.view.position.y, left_point - 0.5,
				left_point + 0.5, render.view.end.y, 0.5
			)
			line1.set_from_points(
				Vector2(render.view.position.x, left_point),
				Vector2(render.view.end.x, right_point),
			)
		var line2 = Line.new()
		match variation:
			LineLineProblem.PARALLEL:
				line2.m = line1.m
				if vertical: line2.b = line1.b + half_n_half(-3.0, -1.0, 1.0, 3.0, 0.25) * line1.m
				else: line2.b = line1.b + half_n_half(-3.0, -1.0, 1.0, 3.0, 0.25)
			LineLineProblem.SECANT:
				var offset: Vector2
				if vertical: offset = line1.get_point_at_y(rand_range(render.view.position.y, render.view.end.y, 0.25))
				else: offset = line1.get_point_at_x(rand_range(render.view.position.x, render.view.end.x, 0.25))
				var angle = (atan(line1.m) + PI / 2) + half_n_half(-PI/4.0, -PI/8.0, PI/8.0, PI/4.0, PI/8.0)
				line2.m = tan(angle)
				line2.b = offset.y + line2.m * -offset.x
			LineLineProblem.PERPENDICULAR:
				var offset: Vector2
				if vertical: offset = line1.get_point_at_y(rand_range(render.view.position.y, render.view.end.y, 0.25))
				else: offset = line1.get_point_at_x(rand_range(render.view.position.x, render.view.end.x, 0.25))
				line2.m = -1.0 / line1.m
				line2.b = offset.y + line2.m * -offset.x

		
		render.add_child(line1)
		render.add_child(line2)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()
