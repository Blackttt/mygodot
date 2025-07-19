extends CharacterBase
class_name Player

func _physics_process(delta):
	if Input.is_action_just_pressed("attack"):
		print("[Player] 攻击键按下")
		state_machine.request_state_change("Attack")
		return

	if Input.is_action_just_pressed("roll"):
		print("[Player] 翻滚键按下")
		state_machine.request_state_change("Roll")
		
	# 检测是否需要移动
	var moving := Input.get_vector("move_down","move_left","move_right","move_up")

	if moving:
		state_machine.request_state_change("Move")
