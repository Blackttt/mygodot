# StateMachine.gd
extends Node
class_name StateMachine

var states: Dictionary = {}
var current_state: State = null

func _ready() -> void:
	# 注册所有子状态，这个逻辑保持不变，非常完美
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.state_machine = self
			child.character = get_parent()
	print("[StateMachine] 状态列表已初始化：", states.keys())

# process函数保持不变，用于处理非物理逻辑
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

# 【核心修改】现在由状态机自己来驱动当前状态的物理更新
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
		
# 状态切换的请求函数，保持不变
func request_state_change(name: String, payload: Dictionary = {}):
	if not states.has(name):
		push_error("[StateMachine] 状态不存在：%s" % name)
		return

	if current_state and current_state.name == name:
		if current_state.has_method("update_data"):
			current_state.update_data(payload)
		return

	if current_state:
		current_state.exit()
	var old_state_name = current_state.name if current_state != null else "null"
	print("[StateMachine] 状态切换：%s → %s" % [old_state_name, name])

	current_state = states[name]
	current_state.enter(payload)
