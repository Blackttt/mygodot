# StateMachine.gd
extends Node
class_name StateMachine

var states: Dictionary = {}
var current_state: State = null

var _components: Dictionary = {} 

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

# 【核心修正！】setup_controllers 方法现在接收字典形式的组件
func setup_controllers(components_dict: Dictionary):
	# 将传入的组件字典直接赋值给内部字典
	_components = components_dict

	# 【重要！】在这里将 Character 引用传递给所有子状态
	# 确保 _components 中有 "character" 键且是 Character 类型
	if not _components.has("character") or not (_components["character"] is CharacterBody2D):
		push_error("[StateMachine] setup_controllers 缺少 'character' 组件或类型不正确喵！无法初始化状态的角色引用。")
		return
		
	for state_name in states:
		var state_instance = states[state_name]
		state_instance.character = _components["character"] # 所有 State 实例都能访问 Character

	# 初始化状态机的初始状态 (在所有依赖都设置好之后)
	request_state_change("Idle")
	
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
	
	play_anim() 
	
# 统一播放当前状态动画的方法
func play_anim():
	# 现在从 _components 字典中获取 anim_ctrl
	var anim_ctrl_ref = _components.get("anim_ctrl")
	if anim_ctrl_ref and anim_ctrl_ref is AnimationController: # 额外进行类型检查更安全
		anim_ctrl_ref.play_current_state_animation()
	else:
		push_error("[StateMachine] AnimationController 未设置或类型不正确，无法播放动画喵！")

# 提供公共方法让状态可以获取组件引用 (现在直接从字典获取)
func get_component(component_name: String):
	# 直接从 _components 字典中获取组件
	if _components.has(component_name):
		return _components[component_name]
	else:
		push_error("[StateMachine] 尝试获取未知组件：%s 喵！请检查拼写或是否已通过 setup_controllers 设置该组件。" % component_name)
		return null
