extends Node2D

func _process(delta):
time+= delta
	if Input.is_action_just_pressed("DEBUG"):
		launch_projectile(global_position,Vector2(1,0),100,45)
	if is_launch:
		z_axis=initial_speed*sin(deg_to_rad(throw_angle_degrees))* time - 0.5 * gravity * pow(time,2)
		
		#if has not touched the ground yet
		if z_axis >0:
			var x_axis: float=initial_speed*cos(deg_to_rad(throw_angle_degrees))*time
			global_position= initial_position + throw_direction * x_axis ##move everything along the 'x axis'
			
			$Projectile.poition.y=-z_axis
			
	
var initial_speed:float
var throw_angle_degrees:float
const gravity: float=9.8
var time: float=0.0

var initial_position:Vector2
var throw_direction: Vector2

var z_axis=0.0 #simulate throwing the projectile by adding the z axis to the y axis
var is_launch:bool= false




func launch_projectile(initial_pos: Vector2,direction: Vector2,desired_dist:float,desired_angle_deg: float):
	initial_position= initial_pos
	throw_direction=direction.normalized()
	# find initial speed based on desired distance (R) and desired angle (theta)
	throw_angle_degrees=desired_angle_deg
	
	initial_speed=pow(desired_dist*gravity/ sin(2*deg_to_rad(desired_angle_deg)),0.5)
	global_position=initial_position
	time=0.0
	
	z_axis=0
	is_launch=true 
