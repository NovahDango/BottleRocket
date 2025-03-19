extends Node

signal game_started
signal game_over

@onready var bottle = $Bottle




func start_game():
	print("Starting Game")
	emit_signal("game_started")
	
func end_game():
	print("Game Over!")
	emit_signal("game_over")
	
