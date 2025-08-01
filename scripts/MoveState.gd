# MoveState.gd (修正后 - 调用 MovementComponent)
extends State

func enter(payload: Dictionary = {}) -> void:
	print("[MoveState] 进入移动状态")

func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		state_machine.request_state_change("Attack")
		return
	
	var moving_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var movement_comp = state_machine.get_component("movement_comp") 

	if movement_comp == null: # 确保 MovementComponent 存在
		push_error("[MoveState] MovementComponent 未找到喵！无法执行移动。")
		return

	if moving_vector != Vector2.ZERO:
		var normalized_moving_vector = moving_vector.normalized() # 【核心修正！】归一化只做一次

		# 【核心修正！】委托给 MovementComponent 的 start_moving 函数
		movement_comp.start_moving(character, normalized_moving_vector, delta)

		character._last_facing_direction = normalized_moving_vector # 【修正！】存归一化方向
		
		state_machine.play_anim() # 播放动画
		
	else:
		# 【核心修正！】委托给 MovementComponent 的 stop_moving 函数
		movement_comp.stop_moving(character) 
		state_machine.request_state_change("Idle")
	
func exit() -> void:
	print("[MoveState] 退出移动状态")

func _on_animation_finished(anim_name: StringName) -> void:
	pass
