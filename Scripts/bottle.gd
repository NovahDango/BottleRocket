extends RigidBody2D

@export var launch_node: Node2D

@export var camera: Camera2D
var CameraScene = preload("res://Scenes/Camera.tscn")


@onready var shake_timer: Timer = $ShakeTimer
#region
# Variables
var dragging = false
var base_speed = 1.0
var max_speed = 250.0
var max_distance = 500.0
var original_position: Vector2
var return_speed : float = 50.0
var shakeTime : float = 5

var last_mouse_pos: Vector2
var total_shake = 0.0
var mouse_inside = false
var target_pos: Vector2
#endregion
func _ready():
	#$RemoteTransform2D.remote_path = camera.get_path()
	# Set the starting position and disable physics freezing.
	original_position = global_position
	target_pos = global_position
	set_freeze_enabled(false)
	
	
func _process(delta):
	# Check for starting and stopping drag based on the left click.
	if not dragging and mouse_inside and Input.is_action_just_pressed("left_click"):
		_start_dragging(get_global_mouse_position())
	elif dragging and not Input.is_action_pressed("left_click"):
		_stop_dragging()
		
		
	
	# If dragging, update the target position and shake amount.
	if dragging:
		var mouse_pos = get_global_mouse_position()
		_update_shake(mouse_pos)
		target_pos = mouse_pos
		_move_toward_target(delta)

# Called when dragging begins.
func _start_dragging(mouse_pos: Vector2):
	dragging = true
	set_freeze_enabled(true)
	# Prevent a sudden jump by starting at the current position.
	target_pos = global_position
	last_mouse_pos = mouse_pos
	_update_shake(mouse_pos)
	# Start shake timer
	shake_timer.start(shakeTime)

# Called when dragging stops.
func _stop_dragging():
	dragging = false
	get_parent().remove_child(camera)
	var camera_instance = CameraScene.instantiate()
	
	add_child(camera_instance)
	dragging = false
	
	
# Update the total shake distance based on mouse movement.
func _update_shake(current_mouse: Vector2):
	var delta_mouse = current_mouse - last_mouse_pos
	total_shake += delta_mouse.length() / 35.0  # Adjust scale if needed.
	last_mouse_pos = current_mouse
	print("Total Shake: ", "%.2f" % total_shake)

# Resets the shake distance (if needed elsewhere).
func reset_shake():
	total_shake = 0.0 

# Smoothly move the object toward the target position.
func _move_toward_target(delta):
	var dist = global_position.distance_to(target_pos)
	# Create a factor between 0 and 1 based on distance (clamped by max_distance).
	var factor = clamp(dist / max_distance, 0.0, 1.0)
	# Interpolate between the base speed and max speed.
	var speed = lerp(base_speed, max_speed, factor)
	# Lerp toward the target position based on the calculated speed.
	global_position = global_position.lerp(target_pos, delta * speed)

# Mouse area signals to know if the mouse is over this object.
func _on_mouse_entered():
	mouse_inside = true

func _on_mouse_exited():
	mouse_inside = false


func _on_shake_timer_timeout() -> void:
	_stop_dragging()
	
	var tween = create_tween()
	
	tween.tween_property(self, "position", Vector2(original_position), 1)
	tween.tween_property(self, "rotation_degrees", 180, 1)
	await tween.finished
	await get_tree().create_timer(1).timeout
	launch_node.launch_bottle(total_shake)
