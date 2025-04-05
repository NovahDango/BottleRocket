extends Control

var Vending_ui_scene = load("res://Scenes/UI/VendingMachineUI.tscn")
var VendingUI = Vending_ui_scene.instantiate()
func _on_fizzmart_pressed() -> void:
	pass # Replace with function body.


func _on_vending_machine_pressed() -> void:
	pass # Replace with function body.


func _on_vending_button_pressed() -> void:
	self.visible
	get_parent().add_child(VendingUI)
	queue_free()
	VendingUI.global_position = Vector2(500, 380)
