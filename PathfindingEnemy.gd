extends CharacterBody2D

# Get the target node to get their position
@export var target : Node2D;
@export var speed : float;

# Navigation parameters
## The allowed distance between the final destination and the intended destination.
@export var target_tolerance : float;
## The distance that the target point can move before recalulating the whole path.
@export var recalculation_tolerance : float;
## The distance that the unit can be away each point on the path.
@export var path_point_tolerance : float;
## The radius to avoid walls.
@export var wall_radius : float;

# Debug line
@export var line : Line2D;

# Movement variables
var move_dir : Vector2 = Vector2.ZERO;

# Pathfinding variables
var target_position : Vector2;
var current_path_point : int = 0;
var current_path : Array[Vector2] = []; # Vector2 Array of the current path to follow


## Move towards the target, avoiding obstacles
func _physics_process(delta: float) -> void:
	
	# Change path if the position is very different
	var current_target_position : Vector2 = target.global_position;
	
	# Check if target is within tolerance
	if((target_position - current_target_position).length() > recalculation_tolerance):
		target_position = current_target_position;
		current_path = create_path_to(target_position);
	
	# Don't do any of this if at path
	if(current_path_point == current_path.size()):
		return;
	
	# Get movement direction
	var relative_target_point_pos : Vector2 = current_path[current_path_point] - global_position;
	move_dir = relative_target_point_pos.normalized();
	
	# Move
	global_position += speed * move_dir * delta;
	
	# Check if close to path point position
	if(relative_target_point_pos.length() < path_point_tolerance):
		current_path_point += 1;
	
	# Reset movement direction
	move_dir *= 0;


## Get the path towards a the specified point
func create_path_to(target_point : Vector2) -> Array[Vector2]:
	
	# Path array
	var result : Array[Vector2] = [];
	
	# Test a straight line
	var current_point_position : Vector2 = global_position;
	result.append(get_next_point(current_point_position, target_point));
	
	# As long as the last point is not the target point
	while(result[result.size() - 1] != target_point):
		pass
	
	# Draw the debug line
	var points_path : PackedVector2Array = [global_position];
	points_path.append_array(result);
	line.points = points_path;
	
	# New path, reset old path inf
	current_path_point = 0;
	
	# Return the result
	return result;


## Get the next position to move to
func get_next_point(from : Vector2, to : Vector2) -> Vector2:
	
	# Initial result
	var result : Vector2 = to;
	
	# Test a line
	var next_test_line : Vector2 = result - from;
	
	# When this finishes, result will be the next point in the path
	var collision_info : KinematicCollision2D;
	while(test_move(transform, next_test_line, collision_info)):
		
		# Get the shape of the collided object
		var collision_rect : Rect2 = collision_info.get_collider_shape().get_rect();
		var c_shape_pos : Vector2 = to_global(collision_rect.position);
		var c_shape_end : Vector2 = to_global(collision_rect.end);
		var c_shape_side_dir : Vector2 = collision_info.get_normal().rotated(PI/2);
		var collision_pos : Vector2 = collision_info.get_position();
		
		# Get the collision position relative to the rectangle length
		var collision_percent : float = c_shape_pos.distance_to(collision_pos) / c_shape_pos.distance_to(c_shape_end);
		
		# Set the new direction
		if(collision_percent < 0.5):
			c_shape_side_dir = c_shape_side_dir * -1;
		
		# Get the next point
		#next_test_line = 
	
	# Return the result
	return result;
