extends Sprite2D

## Let the player move around the target

# Parameters
@export var speed : float;

# Movement variables
var move_dir : Vector2 = Vector2.ZERO;


## Move around the target to pathfind to
func _physics_process(delta: float) -> void:
	
	# Check input
	if(Input.is_action_pressed("ui_up")):
		move_dir.y -= 1;
	if(Input.is_action_pressed("ui_down")):
		move_dir.y += 1;
	if(Input.is_action_pressed("ui_left")):
		move_dir.x -= 1;
	if(Input.is_action_pressed("ui_right")):
		move_dir.x += 1;
	
	# Move the target
	global_position += move_dir.normalized() * speed * delta;
	
	# Reset the movement direction
	move_dir *= 0;
