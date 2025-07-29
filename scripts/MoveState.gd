# MoveState.gd
extends State

# enter函数现在可以用来接收初始的移动向量，但主要逻辑在physics_update
func enter(payload: Dictionary = {}) -> void:
	print("[MoveState] 进入移动状态")

func physics_update(delta: float) -> void:
	# 同样，在移动时也要能响应攻击等更高优先级的动作
	if Input.is_action_just_pressed("attack"):
		state_machine.request_state_change("Attack")
		return
	
	# if Input.is_action_just_pressed("roll"):
	#	state_machine.request_state_change("Roll")
	#	return

	var moving_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if moving_vector != Vector2.ZERO:
		character.velocity = moving_vector.normalized() * character.stats.speed
		character.move_and_slide()
		

		# 获取移动动画方向喵
		var anim_direction = get_move_anim_direction(moving_vector)
		character.play_anim("move" + anim_direction) # 播放 "move_up", "move_down" 等动画喵
		# 【艾露猫新增】更新最后朝向向量喵！
		character._last_facing_direction = anim_direction # 存方向喵
	else:
		state_machine.request_state_change("Idle")
	
	

func exit() -> void:
	# 退出移动状态时，最好将速度清零，避免角色“滑行”
	character.velocity = Vector2.ZERO
	print("[MoveState] 退出移动状态")
	
func get_move_anim_direction(input_vector: Vector2) -> String:
	# 判断优先级：左右 > 上下喵
	if abs(input_vector.x) > abs(input_vector.y): # 横向移动幅度更大喵
		if input_vector.x < 0:
			return "_left"
		else: # input_vector.x > 0
			return "_right"
	else: # 纵向移动幅度更大或纯纵向移动喵
		if input_vector.y < 0:
			return "_up"
		else: # input_vector.y > 0
			return "_down"
	return "" # 没有移动输入，理论上不会走到这里，因为有input才进移动状态喵
