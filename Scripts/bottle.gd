extends Area2D

var dragging = false
var base_follow_speed = 5.0  # Minimum speed when close
var max_follow_speed = 100.0  # Maximum speed when far
var max_distance = 150.0  # Distance where snapping starts to happen

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		dragging = event.pressed

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and !event.pressed:
		dragging = false # Stop dragging even if released outside area

func _process(delta):
	if dragging:
		var mouse_pos = get_global_mouse_position()
		var distance = global_position.distance_to(mouse_pos)
		
		# Normalize distance to a range of [0, 1]
		var lerp_factor = clamp(distance / max_distance, 0.0, 1.0)

		# Adjust speed based on distance (smooth when close, fast when far)
		var follow_speed = lerp(base_follow_speed, max_follow_speed, lerp_factor)

		# Apply movement with variable easing
		global_position = global_position.lerp(mouse_pos, delta * follow_speed)
