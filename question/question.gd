extends Control

enum LineLineProblem {
	SECANT,
	PERPENDICULAR,
	PARALLEL
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

var problem: ProblemType
var answer: int
func _ready() -> void:
	Global.start_time = Time.get_ticks_msec()
	Global.right = 0
	Global.wrong = 0
	%ProblemCount.text = TranslationServer.translate("problem_count") % [0, 0]
	update_time()
	%Finish.pressed.connect(finish)
	%Button1.pressed.connect(answered.bind(0))
	%Button2.pressed.connect(answered.bind(1))
	%Button3.pressed.connect(answered.bind(2))
	
	generate_problem()
	await get_tree().process_frame
	update_rect()
	%MathRenderer.resized.connect(update_rect)

func update_rect():
	var render = %MathRenderer
	var view = render.view
	var ssize = render.size
	render.view.size.y = 10
	render.view.size.x = ssize.x * (view.size.y / ssize.y)
	render.view.position = render.view.size / -2.0
func generate_problem():
	for last_shape in %MathRenderer.get_children():
		last_shape.queue_free()
		
	if Global.mode == Global.Modes.LineLine:
		generate_line_line_problem()
		return
	if Global.mode == Global.Modes.CircleLine:
		generate_circle_line_problem()
		return
	
	var probType: ProblemType = ProblemType.values().pick_random()
	problem = probType
	match probType:
		ProblemType.CircleLine: generate_circle_line_problem()
		ProblemType.LineLine: generate_line_line_problem()

func generate_circle_line_problem():
	var render = %MathRenderer
		
	%Button1.text = TranslationServer.translate("circle_line_option1")
	%Button2.text = TranslationServer.translate("circle_line_option2")
	%Button3.text = TranslationServer.translate("circle_line_option3")
	var variation = CircleLineProblem.values().pick_random()
	answer = variation
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
	
	line.color = Color.from_hsv(randf(), 1.0, 1.0)
	circle.color = Color.from_hsv(randf(), 1.0, 1.0)
	%Title.text = TranslationServer.translate("circle_line_problem_title")
	%Desc.text = \
	"[color=%s]%s[/color]" % [circle.color.to_html(), str(circle)] + \
	"\n" + "[color=%s]%s[/color]" % [line.color.to_html(), str(line)]

func generate_line_line_problem():
	var render = %MathRenderer
	
	%Button1.text = TranslationServer.translate("line_line_option1")
	%Button2.text = TranslationServer.translate("line_line_option2")
	%Button3.text = TranslationServer.translate("line_line_option3")
	var variation = LineLineProblem.values().pick_random()
	answer = variation
	var line1 = Line.new()
	var line2 = Line.new()
	
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
	
	match variation:
		LineLineProblem.PARALLEL:
			line2.m = line1.m
			if vertical: line2.b = line1.b + half_n_half(-3.0, -1.0, 1.0, 3.0, 0.25) * line1.m
			else: line2.b = line1.b + half_n_half(-3.0, -1.0, 1.0, 3.0, 0.25)
		LineLineProblem.SECANT, LineLineProblem.PERPENDICULAR:
			var offset: Vector2
			if vertical: offset = line1.get_point_at_y(rand_range(render.view.position.y, render.view.end.y, 0.25))
			else: offset = line1.get_point_at_x(rand_range(render.view.position.x, render.view.end.x, 0.25))
			if variation == LineLineProblem.PERPENDICULAR:
				line2.m = -1.0 / line1.m
			if variation == LineLineProblem.SECANT:
				var angle = (atan(line1.m) + PI / 2) + half_n_half(-PI/4.0, -PI/8.0, PI/8.0, PI/4.0, PI/8.0)
				line2.m = tan(angle)
			line2.b = offset.y + line2.m * -offset.x

	
	line1.color = Color.from_hsv(randf(), 1.0, 1.0)
	line2.color = Color.from_hsv(randf(), 1.0, 1.0)
	render.add_child(line1)
	render.add_child(line2)
	
	%Title.text = TranslationServer.translate("line_line_problem_title")
	%Desc.text = \
	"[color=%s]%s[/color]" % [line1.color.to_html(), str(line1)] + \
	"\n" + "[color=%s]%s[/color]" % [line2.color.to_html(), str(line2)]

func answered(option: int) -> void:
	if option == answer:
		$Wrong.stop()
		$Correct.play()
		Global.right += 1
	else:
		$Correct.stop()
		$Wrong.play()
		Global.wrong += 1
	%ProblemCount.text = TranslationServer.translate("problem_count") % [Global.right, Global.wrong]
	generate_problem()

func _process(_delta: float) -> void:
	update_time()
func update_time():
	var seconds: float = (Time.get_ticks_msec() - Global.start_time) / 1000.0
	var minutes: float = seconds / 60.0
	seconds = fmod(seconds, 60.0)
	%Time.text = TranslationServer.translate("time") % [minutes, seconds]

func finish():
	get_tree().change_scene_to_file("res://finish/finish.tscn")
