# NPC_MoveState.gd
extends State

func physics_update(delta: float):
	# 移动时，攻击的优先级更高
	if character.attack_requested:
		state_machine.request_state_change("Attack")
		character.attack_requested = false
		return
	
	# 从“公告板”读取大脑的当前移动意图
	var move_vec = character.desired_move_vector

	if move_vec == Vector2.ZERO:
		# 大脑的意图是停止，我的任务结束了，返回待机。
		state_machine.request_state_change("Idle")
		return

	# 持续委托给MovementComponent来执行移动
	var movement_comp = state_machine.get_component("movement_comp")
	if movement_comp:
		movement_comp.start_moving(character, move_vec, delta)
		character._last_facing_direction = move_vec
		state_machine.play_anim()
	
func exit():
	# 退出逻辑保持不变，确保速度归零
	var movement_comp = state_machine.get_component("movement_comp")
	if movement_comp:
		movement_comp.stop_moving(character)
