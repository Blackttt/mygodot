# hit_state.gd
extends State
class_name HitState

func enter(payload: Dictionary = {}):
	print("[sandbag_idle_state] 我挨打了！")
	
	
# 动画播放完毕后，由这个函数接管
func _on_animation_finished(anim_name: StringName):
	# 确保是受击动画结束了
	if anim_name.begins_with("hit"):
		# 动画播完了，就回到待机状态
		state_machine.request_state_change("Idle")
