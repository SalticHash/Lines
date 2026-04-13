extends Control


# Called when the node enters the scene tree for the first time.
var language_idx = 0
var languages = [
	"en_US", "English",
	"es_CR", "Español"
]
func _ready() -> void:
	$LineLine.pressed.connect(mode_pressed.bind(Global.Modes.LineLine))
	$CircleLine.pressed.connect(mode_pressed.bind(Global.Modes.CircleLine))
	$Mixed.pressed.connect(mode_pressed.bind(Global.Modes.Mixed))
	$ToggleLanguage.pressed.connect(toggle_language)
func mode_pressed(mode: Global.Modes):
	Global.mode = mode
	get_tree().change_scene_to_file("res://question/question.tscn")

func toggle_language():
	language_idx = (language_idx + 1) % int(languages.size() / 2.0)
	var idx = language_idx * 2
	$ToggleLanguage.text = languages[idx + 1]
	TranslationServer.set_locale(languages[idx])
	
