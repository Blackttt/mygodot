extends Node
class_name StateMachine

var states: Dictionary = {}
var current_state: State = null

var transition_locked: bool = false
var pending_state_name: String = ""

func _ready():
	# 注册所有子状态
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.state_machine = self
			child.character = get_parent()
	print("[StateMachine] 状态列表已初始化：", states.keys())

func _process(delta):
	if current_state:
		current_state.update(delta)

func request_state_change(name: String):
	if not states.has(name):
		push_error("[StateMachine] 状态不存在：%s" % name)
		return
		
	if current_state and current_state.name == name:
		return  # 不重复切换同一个状态
		
	if current_state:
		current_state.exit()
	var old_state_name = current_state.name if current_state != null else "null"
	print("[StateMachine] 状态切换：%s → %s" % [old_state_name, name])

	current_state = states[name]
	current_state.enter()
