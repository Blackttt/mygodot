# HealthComponent.gd (修正后)
extends Node
class_name HealthComponent

signal died
signal hp_changed(current_hp_value: int, max_hp_value: int) # 【信号回到这里发出】喵！

@export var stats_resource: CharacterStats # 这个仍然引用外部的 Stats 资源（模板数据）

var current_hp: int # 【关键！】当前生命值放在这里，每个HealthComponent实例独享！
var defense: int # 【关键！】防御力也可以从 Stats 资源读取一份到这里，确保运行时独享

func _ready():
	if stats_resource == null:
		push_error("[HealthComponent] stats_resource 未设置喵！")
		return

	# 初始化当前生命值和防御力
	current_hp = stats_resource.max_hp # 从 Stats 资源中读取 max_hp 来初始化
	defense = stats_resource.defense # 从 Stats 资源中读取 defense 来初始化

	print("[HealthComponent] 初始化，当前HP: %d/%d，防御: %d 喵！" % [current_hp, stats_resource.max_hp, defense])

# 这是处理外部伤害调用的方法
func apply_damage(amount: int):
	# 使用 HealthComponent 自己的 defense 属性
	var damage = max(amount - defense, 1) 
	current_hp = max(current_hp - damage, 0)
	
	print("[HealthComponent] 受到伤害：%d，当前HP：%d 喵！" % [damage, current_hp])
	
	# 发出 hp_changed 信号
	hp_changed.emit(current_hp, stats_resource.max_hp) # max_hp 依然从 stats_resource 获取

	if current_hp <= 0:
		died.emit() # 组件发出死亡信号

# 提供公共方法，让外部可以获取当前生命值
func get_current_hp() -> int:
	return current_hp

func get_max_hp() -> int:
	if stats_resource:
		return stats_resource.max_hp
	return 0
