# upgrade_option.gd
extends Control

var upgrade_data: Upgrade

@onready var title: Label = $Upgrade/MarginContainer/VBoxContainer/Title
@onready var icon: TextureRect = $Upgrade/MarginContainer/VBoxContainer/MarginContainer/Icon
@onready var description: Label = $Upgrade/MarginContainer/VBoxContainer/Description

signal upgrade_selected(data: Upgrade)

func set_upgrade(data: Upgrade):
	upgrade_data = data
	icon.texture = data.Icon
	title.text = data.Name
	description.text = data.desc
	


func _on_upgrade_pressed() -> void:
	emit_signal("upgrade_selected", upgrade_data)
