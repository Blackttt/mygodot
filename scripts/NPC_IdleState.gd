# NPC_IdleState.gd
extends State

func enter(payload: Dictionary = {}):
	print("[NPC_IdleState] 进入待机，等待大脑指令...")

func physics_update(delta: float):
	# 检查大脑是否请求攻击
	if character.attack_requested:
		state_machine.request_state_change("Attack")
		#【重要】响应后要立刻清除请求，避免重复攻击
		character.attack_requested = false 
		return

	# 检查大脑是否想移动
	if character.desired_move_vector != Vector2.ZERO:
		state_machine.request_state_change("Move")
