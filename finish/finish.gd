extends Control


func _ready() -> void:
	%ProblemCount.text = TranslationServer.translate("problem_count") % [Global.right, Global.wrong]
	update_time()

func update_time():
	var seconds: float = (Time.get_ticks_msec() - Global.start_time) / 1000.0
	var minutes: float = seconds / 60.0
	seconds = fmod(seconds, 60.0)
	%Time.text = TranslationServer.translate("time") % [minutes, seconds]

func _on_go_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
