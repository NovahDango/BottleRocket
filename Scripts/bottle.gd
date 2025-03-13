extends RigidBody2D

# --- Exports ---
@export var launch_node: Node2D



# --- Variables ---
var dragging := false
var base_follow_speed := 1.0
var max_follow_speed := 250.0
var max_distance := 500.0

var last_mouse_position: Vector2
var total_shake_distance := 0.0
var mouse_inside := false
var target_position: Vector2

# --- Initialization ---
func _ready():
	target_position = global_position  # Ensure correct starting position of Bottle
	set_freeze_enabled(false)
# --- Input Handling ---
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and mouse_inside:
		start_dragging(event.position)
		update_shake_distance(event.position)
		
	if event is InputEventMouseButton and not event.pressed:
		stop_dragging()
		

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion and dragging:
		update_shake_distance(event.position)

	if event is InputEventMouseButton and not event.pressed:
		stop_dragging()
		

# --- Dragging Functions ---
func start_dragging(mouse_pos: Vector2):
	dragging = true
	set_freeze_enabled(true)
	last_mouse_position = mouse_pos  # Store click position
	target_position = global_position  # Keep the object stable at start

func stop_dragging():
	dragging = false
	launch_node.launch_bottle(total_shake_distance)
	


func update_shake_distance(current_mouse_position: Vector2):
	var delta_pos = current_mouse_position - last_mouse_position
	var shake_movement = delta_pos.length() / 100
	
	total_shake_distance += shake_movement  # CALCULATES TOTAL SHAKE DISTANCE P SIMPLE
	last_mouse_position = current_mouse_position
	print("Total Shake Distance: ","%.2f" % total_shake_distance )
	
func reset_shake_distance():
	total_shake_distance = 0.0 
	

# --- Movement Logic ---
func _process(delta):
	if dragging:
		target_position = get_global_mouse_position()  # Update target position

		move_toward_target(delta)

func move_toward_target(delta):
	var distance = global_position.distance_to(target_position)
	var lerp_factor = clamp(distance / max_distance, 0.0, 1.0)
	var follow_speed = lerp(base_follow_speed, max_follow_speed, lerp_factor)

	global_position = global_position.lerp(target_position, delta * follow_speed)

# --- Mouse Events ---
func _on_mouse_entered():
	mouse_inside = true

func _on_mouse_exited():
	mouse_inside = false
