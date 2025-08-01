# IdleState.gd
extends State

func enter(payload: Dictionary = {}) -> void:
	print("[IdleState] 进入待机状态")
	# 进入待机时，确保角色速度归零
	character.velocity = Vector2.ZERO

func physics_update(delta: float) -> void:
	# 在待机状态下，持续检查玩家是否想做点什么

	# 1. 检查是否要攻击或翻滚 (高优先级动作)
	if Input.is_action_just_pressed("attack"):
		state_machine.request_state_change("Attack")
		return # 发现意图，立刻请求切换，不再做其他检查
	
	# if Input.is_action_just_pressed("roll"):
	#	state_machine.request_state_change("Roll")
	#	return

	# 2. 检查是否要移动
	var moving_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if moving_vector != Vector2.ZERO:
		# 如果有移动输入，就切换到移动状态
		state_machine.request_state_change("Move", {"input_vector": moving_vector})
		return

# IdleState.gd (建议修正)
func _on_animation_finished(anim_name: StringName) -> void:
	# 待机动画通常是循环的，在这里不需要处理状态切换喵
	pass # 保持为空函数
