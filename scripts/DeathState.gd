extends State
class_name DeathState

func enter(payload: Dictionary = {}):
	print("[DeathState] 角色死亡")

# DeathState.gd (建议修正)
func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name.begins_with("death"): # 判断是死亡动画结束
		print("[DeathState] 死亡动画播放完毕，准备移除角色喵！")
		# 可以在这里添加真正的移除逻辑，例如：
		# if character:
		#    character.queue_free()
		# 或者向 HealthComponent 或 Character 自身发出信号，由宿主决定如何处理死亡
