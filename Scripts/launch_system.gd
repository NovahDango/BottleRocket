extends Node2D

@export var bottle: RigidBody2D  # Reference to your Bottle (must be a RigidBody2D)
@export var powerup_multiplier: float = 1.0  # Multiplier to boost launch force with power-ups
@export var max_launch_force: float = 5000.0  # Cap for the launch force



func launch_bottle(shake_force: float) -> void:
	
	if not bottle:
		print("No bottle assigned to launch system!")
		return

	# Calculate the launch force based on shake force and power-up multiplier.
	# Adjust the scaling factor (here, 100) as needed for your game.
	var launch_force = min(shake_force * 2 * powerup_multiplier, max_launch_force)
	bottle.set_freeze_enabled(false)
	
	# Generate a slight random horizontal offset.
	# Adjust range as needed, here -0.2 to 0.2 creates small left/right deviation.
	var random_offset = randf_range(-0.1, 0.1)
	
	var launch_direction = Vector2(random_offset, 1).normalized()
	
	# Apply an upward impulse at the center of the bottle.
	bottle.apply_impulse(-launch_direction * launch_force, Vector2.ZERO)
	
	print("Launched with Force:", launch_force)
