# AttackState.gd
# 使用 animation_finished 信号来控制攻击流程的状态脚本。
extends State

# ## 组件引用 ##
var anim_player: AnimationPlayer

# ## Godot 方法 ##
# 状态节点在场景加载时会调用一次 _ready
func _ready() -> void:
		anim_player = character.get_node("AnimationPlayer")
	
# ## 状态生命周期函数 ##
# 当进入攻击状态时调用
func enter(payload: Dictionary = {}) -> void:
	var attack_comp = state_machine.get("attack_comp")
	
	# 1. 执行攻击逻辑，委托给 AttackComponent
	attack_comp.perform_attack()
	
	# 2. 播放攻击动画
	character.play_anim("attack" + character._last_facing_direction) # 调用Character脚本里的辅助函数
	
	# 3. 连接 animation_finished 信号
	#    当动画播放器完成任何动画时，都会通知我们。
	#    我们检查一下是否已连接，避免重复连接。
	if not anim_player.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		anim_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

# 当离开攻击状态时调用
func exit() -> void:
	# 这是一个非常好的习惯：离开状态时，断开信号连接。
	# 避免我们在“空闲”或“移动”状态时，仍然错误地响应攻击动画结束的信号。
	if anim_player.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		anim_player.disconnect("animation_finished", Callable(self, "_on_animation_finished"))
	
	var attack_comp = state_machine.get("attack_comp")
	if attack_comp:
		attack_comp.disable_attack()
	
	print("[AttackState] 退出攻击状态喵！")

# ## 信号处理函数 ##
# 当任何动画结束时，这个函数都会被调用
func _on_animation_finished(anim_name: StringName) -> void:
	# **关键检查**：确保是“攻击”动画结束了，而不是其他动画（比如idle循环了一次）
	if anim_name.begins_with("attack"):
		# 请求切换回空闲状态
		# 状态机将会调用我们上面写的 exit() 函数来清理
		if state_machine:
			state_machine.request_state_change("Idle")
