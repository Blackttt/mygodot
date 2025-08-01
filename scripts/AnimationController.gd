# AnimationController.gd (修正后)
extends Node # 继承 Node
class_name AnimationController

var _anim_player: AnimationPlayer # 运行时引用，现在自动获取
var _host_character: CharacterBody2D # 【新增！】引用宿主 Character，用于获取朝向向量
var _state_machine: StateMachine # 【新增！】引用状态机，用于获取当前状态名

# 动画播放完成信号，可以转发给宿主（Character）
signal animation_finished(anim_name)


func _ready():
	# 自动获取 AnimationPlayer
	# 通常 AnimationPlayer 是 Character 的直接子节点
	# 如果 AnimationController 也是 Character 的直接子节点，那么 $AnimationPlayer 即可
	# 如果 AnimationController 挂载在 Character 的孙子节点，可能需要更复杂的路径或 get_parent() 链
	_anim_player = get_parent().get_node_or_null("AnimationPlayer") # 假设 AnimationPlayer 是我的兄弟节点

	if _anim_player == null:
		# 尝试在父级节点中查找，以防 AnimationPlayer 不在直接兄弟节点
		_anim_player = get_node_or_null("../AnimationPlayer") # 向上查找一级
		if _anim_player == null:
			# 最终回退到在整个场景树中查找 Character 下的 AnimationPlayer
			# 这取决于你的 Character 场景结构。这里假设 AnimationPlayer 是 Character 的子节点
			var character_node = get_owner() # get_owner() 会返回这个节点被实例化的场景的根节点
			if character_node is Character:
				_host_character = character_node
				_anim_player = _host_character.get_node_or_null("AnimationPlayer")

	if _anim_player == null:
		push_error("[AnimationController] 未能在场景中找到 AnimationPlayer 节点！请检查场景结构喵！")
	else:
		print("[AnimationController] 成功获取到 AnimationPlayer: %s 喵！" % _anim_player.name)
		# 统一连接 AnimationPlayer 的 animation_finished 信号
		if not _anim_player.is_connected("animation_finished", Callable(self, "_on_animation_finished_internal")):
			_anim_player.connect("animation_finished", Callable(self, "_on_animation_finished_internal"))

# 【新增方法】由宿主（Character）在初始化时调用，传入 Character 和 StateMachine 引用
func setup_controllers(host: CharacterBody2D, state_machine_ref: StateMachine):
	_host_character = host
	_state_machine = state_machine_ref # 【新增！】设置状态机引用
	if _host_character == null or _state_machine == null:
		push_error("[AnimationController] 宿主 Character 或 StateMachine 引用未正确设置喵！")

# 【核心修正！】无参数的动画播放方法
func play_current_state_animation(): 
	if _anim_player == null or _host_character == null or _state_machine == null:
		push_error("[AnimationController] 无法播放动画：AnimationPlayer, 宿主 Character 或 StateMachine 为空喵！")
		return
	if _state_machine.current_state == null:
		push_warning("[AnimationController] 状态机当前状态为 Nil，无法播放动画喵！")
		return

	var state_name = _state_machine.current_state.name.to_lower() # 获取当前状态名并转小写 (例如 "idle", "move", "attack")
	var anim_name: String
	var direction_suffix: String = ""

	# 获取朝向后缀
	if _host_character.has_method("get_facing_anim_direction"):
		direction_suffix = _host_character.get_facing_anim_direction()
	else:
		push_warning("[AnimationController] 宿主 Character 缺少 get_facing_anim_direction 方法喵！")

	# 根据状态类型和朝向拼接动画名
	anim_name = state_name + direction_suffix

	if not _anim_player.has_animation(anim_name):
		push_warning("[AnimationController] 动画 '%s' 不存在喵！尝试播放无方向默认动画或跳过喵。" % anim_name)
		if _anim_player.has_animation(state_name):
			anim_name = state_name # 回退到播放没有方向后缀的动画
		else:
			push_error("[AnimationController] 基础动画 '%s' 也不存在喵！无法播放动画！" % state_name)
			return # 如果连基础动画都没有，就直接返回

	# 播放动画
	if _anim_player.current_animation != anim_name:
		_anim_player.play(anim_name)
		print("[AnimationController] 播放动画：%s 喵！" % anim_name)

# 内部信号处理函数，用于转发信号
func _on_animation_finished_internal(anim_name: StringName):
	animation_finished.emit(anim_name) # 转发信号
	print("[AnimationController] 动画结束，转发信号：%s 喵！" % anim_name)

# 额外提供一些有用的公共方法 (可选)
func get_current_animation() -> String:
	if _anim_player:
		return _anim_player.current_animation
	return ""
