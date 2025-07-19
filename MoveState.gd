extends State
class_name MoveState

func enter():
	print("[MoveState] 进入移动状态")
	# 不立即播放动画，等待 physics_update 根据方向决定

func exit():
	print("[MoveState] 退出移动状态")
	character.velocity = Vector2.ZERO

func physics_update(delta):
	var input_vector = Input.get_vector("move_down","move_left","move_right","move_up")

	if input_vector == Vector2.ZERO:
		state_machine.request_state_change("Idle")
		return

	# 设置移动速度
	character.velocity = input_vector * character.stats.speed
	print("velocity is ",character.velocity)
	character.move_and_slide()

	# 播放方向对应动画
	if abs(input_vector.x) > abs(input_vector.y):
		if input_vector.x > 0:
			character.play_anim("move_right")
		else:
			character.play_anim("move_left")
	else:
		if input_vector.y > 0:
			character.play_anim("move_down")
		else:
			character.play_anim("move_up")
