extends Node

enum Modes {
	LineLine,
	CircleLine,
	Mixed
}
var mode: Modes = Modes.LineLine
var right: int = 0
var wrong: int = 0
var start_time: int = -1
