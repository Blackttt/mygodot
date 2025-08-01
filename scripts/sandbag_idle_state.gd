# sandbag_idle_state.gd
extends State

func enter(payload: Dictionary = {}):
	pass

# 物理帧更新也留空，因为它不会自己移动或攻击
func physics_update(delta: float):
	pass
