extends RigidBody3D
## how much force to apply up when moveing
@export_range(0.0, 3000.0) var thrust: float = 1000.0
## how much rotation to apply when moveint
@export_range(0.0, 300.0) var torque: float = 100.0

var is_transitioning: bool = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
	if Input.is_action_pressed("Left_A"):
		apply_torque(Vector3(0.0, 0.0, torque  * delta))
	if Input.is_action_pressed("Right_D"):
		apply_torque(Vector3(0.0, 0.0, -torque * delta))


func _on_body_entered(body: Node) -> void:
	if is_transitioning == false:
		if "Goal" in body.get_groups():
			complete_level(body.file_path)
		elif "Lose" in body.get_groups():
			crash_sequence()
		print(body.name)


func crash_sequence() -> void:
	print("KABOOM!#")
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(get_tree().reload_current_scene)

	
func  complete_level(next_level_file: String) -> void:
	print("win")
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))
