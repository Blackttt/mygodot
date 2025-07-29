# AttackComponent.gd
extends Node # 继承 Node
class_name AttackComponent

@export var melee_hitbox_path: NodePath # 在编辑器中把你的 MeleeHitbox 节点拖到这里喵！
var _melee_hitbox: Hitbox # 运行时引用

var _character_stats: CharacterStats # 【重要！】引用宿主的 CharacterStats 资源喵！

func _ready():
	# 延迟获取 MeleeHitbox，确保它已加载
	await get_tree().process_frame
	if get_node_or_null(melee_hitbox_path):
		_melee_hitbox = get_node(melee_hitbox_path)
	
	if _melee_hitbox == null:
		push_error("[AttackComponent] 未找到 MeleeHitbox！请检查 melee_hitbox_path 喵！")

# 【新增方法】由宿主（Character）在初始化时调用，传入 CharacterStats 引用
func setup_stats(stats_res: CharacterStats):
	_character_stats = stats_res
	if _character_stats == null:
		push_error("[AttackComponent] CharacterStats 引用未正确设置喵！")

# 执行攻击的方法，由 AttackState 调用
func perform_attack():
	if _melee_hitbox == null:
		push_error("[AttackComponent] 无法攻击：MeleeHitbox 为空喵！")
		return
	if _character_stats == null:
		push_error("[AttackComponent] 无法攻击：CharacterStats 为空喵！")
		return

	# 1. 设置伤害并激活Hitbox
	_melee_hitbox.damage = _character_stats.attack # 【获取攻击力！】使用引用的 stats_resource 中的 attack 属性
	_melee_hitbox.get_node("CollisionShape2D").disabled = false
	
	print("[AttackComponent] 执行攻击，伤害值为：%d 喵！" % _character_stats.attack)

# 攻击结束后禁用 Hitbox
func disable_attack():
	if _melee_hitbox:
		_melee_hitbox.get_node("CollisionShape2D").disabled = true
