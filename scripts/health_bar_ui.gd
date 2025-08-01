# health_bar_ui.gd
extends CanvasLayer

# 引用UI节点
@onready var progress_bar: ProgressBar  = $ProgressBar 

# 这个变量用来记住我们正在监控哪个角色的HealthComponent
var _target_health_component: HealthComponent = null


# 提供一个公共方法，让外部来指定这个血条要“监控”谁
func track_character(character_node: CharacterBody2D):
	# 先从角色身上拿到它的HealthComponent
	var health_comp = character_node.health_comp
	if health_comp == null:
		print("错误！这个角色没有HealthComponent，无法追踪血条喵！")
		return

	# 如果之前追踪了别的目标，先“取关”旧的，避免混乱
	if _target_health_component and _target_health_component.is_connected("hp_changed", _on_hp_changed):
		_target_health_component.hp_changed.disconnect(_on_hp_changed)

	# 记录新目标
	_target_health_component = health_comp
	
	# 【关键！】开始“订阅”新目标的血量变化信号
	_target_health_component.hp_changed.connect(_on_hp_changed)
	
	# 【初始化！】为了让血条立刻显示正确的状态，我们手动调用一次更新函数
	# 使用HealthComponent提供的公共方法来获取初始血量
	var current_hp = _target_health_component.get_current_hp() # [cite: 3]
	var max_hp = _target_health_component.get_max_hp() # 
	_on_hp_changed(current_hp, max_hp)

# 当被监控的HealthComponent发出hp_changed信号时，这个函数会自动被调用
func _on_hp_changed(current_hp_value: int, max_hp_value: int):
	# 更新TextureProgressBar的最大值和当前值
	progress_bar.max_value = max_hp_value
	progress_bar.value = current_hp_value
	
	print("UI收到更新！当前血量显示为: %d / %d" % [current_hp_value, max_hp_value])
