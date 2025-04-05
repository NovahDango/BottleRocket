extends Control


var upgradeOption = load("res://Scenes/UI/upgrade_option.tscn")
@onready var h_box_container: HBoxContainer = $MarginContainer/VBoxContainer/UpgradePanel/MarginContainer/HBoxContainer

@onready var all_upgrades: Array[Upgrade] = [
	preload("res://Scripts/Resources/MentosUpgrade.tres"),
	preload("res://Scripts/Resources/PressureCapUpgrade.tres")
]

func _ready() -> void:
	var shuffled = all_upgrades.duplicate()
	shuffled.shuffle()
	
	for i in 2:
		var new_upgrade = upgradeOption.instantiate()
		h_box_container.add_child(new_upgrade)
		new_upgrade.set_upgrade(shuffled[i])
		#new_upgrade.upgrade_selected.connect(_on_upgrade_selected)

func _on_upgrade_selected(data: Upgrade) -> void:
	print("Player chose upgrade:", data.Name)
