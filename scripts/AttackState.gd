# AttackState.gd
# 使用 animation_finished 信号来控制攻击流程的状态脚本。
extends State

# ## 组件引用 ##
var anim_player: AnimationPlayer

# ## Godot 方法 ##
# 状态节点在场景加载时会调用一次 _ready
func _ready() -> void:
	pass
	
# ## 状态生命周期函数 ##
# 当进入攻击状态时调用
func enter(payload: Dictionary = {}) -> void:
	var attack_comp = state_machine.get_component("attack_comp")

	# 1. 执行攻击逻辑，委托给 AttackComponent
	attack_comp.perform_attack()

# 当离开攻击状态时调用
func exit() -> void:
	var attack_comp = state_machine.get_component("attack_comp")
	if attack_comp:
		attack_comp.disable_attack()
	
	print("[AttackState] 退出攻击状态喵！")

# ## 信号处理函数 ##
func _on_animation_finished(anim_name: StringName) -> void:
	# **关键检查**：确保是“攻击”动画结束了，现在判断动画名是否以 "attack" 开头喵！
	if anim_name.begins_with("attack"): # 【修正！】使用 begins_with() 方法
		# 请求切换回空闲状态
		# 状态机将会调用我们上面写的 exit() 函数来清理
		if state_machine:
			state_machine.request_state_change("Idle")
