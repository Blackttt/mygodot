extends CharacterBase
class_name Player

func _physics_process(delta):
	# 1. 检查高优先级的动作 (攻击/翻滚)
	if Input.is_action_just_pressed("attack"):
		print("[Player] 攻击键按下")
		state_machine.request_state_change("Attack")
		return # 攻击时，不再处理本帧的后续输入

	if Input.is_action_just_pressed("roll"):
		print("[Player] 翻滚键按下")
		state_machine.request_state_change("Roll")
		return # 翻滚时，不再处理本帧的后续输入
		
	# 2. 处理移动逻辑
	# 获取移动向量
	var moving_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# 判断是否有移动输入
	if moving_vector != Vector2.ZERO:
		# 如果有，就请求进入或更新“移动”状态
		print("[Player] 移动键按下")
		state_machine.request_state_change("Move", {"input_vector": moving_vector})
	else:
		# 如果没有任何移动输入，就请求进入“空闲”状态
		state_machine.request_state_change("Idle")
