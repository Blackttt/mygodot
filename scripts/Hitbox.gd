# Hitbox.gd
extends Area2D
class_name Hitbox

# 自定义信号：当命中Hurtbox时发出。
signal hurtbox_hit(hurtbox)

@export var damage: int

# 节点准备就绪时，用代码将内置信号连接到处理函数。
func _ready() -> void:
	area_entered.connect(_on_area_entered)

# 当有Area2D进入时，此函数被调用。
func _on_area_entered(hurtbox: Hurtbox) -> void:
	# 发射我们自定义的"hurtbox_hit"信号。
	emit_signal("hurtbox_hit", hurtbox)

# 公共方法，让别人可以获取它的伤害值。
func get_damage() -> int:
	return damage
