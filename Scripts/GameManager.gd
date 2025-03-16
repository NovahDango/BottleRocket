extends Node

signal game_started
signal game_over

enum gameState {STATE_MAINMENU, STATE_SHAKE, STATE_PILOT, STATE_UPGRADE}



func main_Menu():
	print("")

func start_game():
	print("Starting Game")
	emit_signal("game_started")
	
func end_game():
	print("Game Over!")
	emit_signal("game_over")
	
