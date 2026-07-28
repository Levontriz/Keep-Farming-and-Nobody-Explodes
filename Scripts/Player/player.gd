extends CharacterBody2D


const SPEED = 75.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	if direction:
		velocity = direction.normalized() * SPEED
	else:
		velocity = velocity/2

	move_and_slide()
