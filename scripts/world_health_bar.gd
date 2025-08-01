# world_health_bar.gd (智能化修改后)
extends Node

@onready var progress_bar: ProgressBar = $ProgressBar

func _ready():
	# 艾露猫魔法时间！让血量条自己找到需要的数据源喵！
	# 1. 向上找到父节点 (Sandbag)
	var parent_character = get_parent()
	if not parent_character:
		push_error("[WorldHealthBar] 找不到父节点！")
		return

	# 2. 从父节点那里找到兄弟节点 HealthComponent
	var health_comp = parent_character.get_node_or_null("HealthComponent")
	
	if health_comp:
		# 3. 连接 "hp_changed" 信号到自己的更新方法
		health_comp.hp_changed.connect(_on_hp_changed)
		
		# 4. 初始化一次血条，让它显示满血状态
		var max_hp = health_comp.get_max_hp()
		_on_hp_changed(max_hp, max_hp)
	else:
		push_error("[WorldHealthBar] 在父节点 %s 中找不到 HealthComponent！" % parent_character.name)



# 公共的更新方法，保持不变
func _on_hp_changed(current_hp: int, max_hp: int):
	progress_bar.max_value = max_hp
	progress_bar.value = current_hp
