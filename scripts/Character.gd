# Character.gd 
# 融合了状态机和Hurtbox碰撞系统的最终角色模板
extends CharacterBody2D
class_name Character

# ## 属性与组件 ##
@onready var state_machine: Node = $StateMachine
@onready var anim_ctrl: AnimationController = $AnimationController
# 【新增】组件引用：引用我们之前设计的“护甲片”
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health_comp: HealthComponent = $HealthComponent
@onready var attack_comp: AttackComponent = $AttackComponent 
@onready var movement_comp: MovementComponent = $MovementComponent

@export var stats_resource: CharacterStats

var _last_facing_direction: Vector2 = Vector2.DOWN

# ## Godot 方法 ##
func _ready():
	# 1. 组件空值检查
	# 提前检查所有 @onready 变量，如果为 null，直接报错并返回
	if health_comp == null:
		push_error("[Character] HealthComponent 未找到喵！")
		return
	if anim_ctrl == null:
		push_error("[Character] AnimationController 未找到喵！请确保场景中存在该节点！")
		return
	if hurtbox == null: # 假设 hurtbox 也是必须的
		push_error("[Character] Hurtbox 未找到喵！")
		return
	if attack_comp == null:
		push_error("[Character] AttackComponent 未找到喵！")
		return
	if movement_comp == null: # 【艾露猫修改！】新增 MovementComponent 的空值检查
		push_error("[Character] MovementComponent 未找到喵！请检查场景中是否存在该节点。")
		return # 【艾露猫修改！】加上 return
	if state_machine == null:
		push_error("【致命错误】喵！Character的_ready中，StateMachine是Nil！")
		return
	
	health_comp.setup_stats(stats_resource)
	attack_comp.setup_stats(stats_resource)
	movement_comp.setup_stats(stats_resource)
	
	health_comp.died.connect(Callable(self, "_on_died"))
	health_comp.hp_changed.connect(Callable(self, "_on_hp_changed_in_ui"))
	hurtbox.hit.connect(on_hurtbox_hit)
	
	# 3. 初始化 AnimationController
	anim_ctrl.setup_controllers(self, state_machine) # 传递 Character 自身给 AnimationController
	# 连接 AnimationController 发出的 animation_finished 信号，并委托给状态机
	if not anim_ctrl.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		anim_ctrl.connect("animation_finished", Callable(self, "_on_animation_finished"))
			
	# 4. 【核心！】构建组件字典并传递给 StateMachine 进行依赖注入
	var components_to_setup: Dictionary = {
		"character": self, # 角色自身作为“组件”传递给状态机，方便状态访问
		"anim_ctrl": anim_ctrl,
		"health_comp": health_comp,
		"attack_comp": attack_comp,
		"movement_comp": movement_comp # 如果有 movement_comp，也要在这里添加
	}
	state_machine.setup_controllers(components_to_setup) # 【关键！】将所有组件一次性注入状态机
	print("[Character] 玩家角色已准备就绪喵！")
	
	
# ## 信号处理 ##
# 【新增】当Hurtbox发出"hit"信号时，这个函数会被调用
func on_hurtbox_hit(hitbox: Hitbox) -> void:
	if health_comp:
		health_comp.apply_damage(hitbox.get_damage()) # 委托伤害处理

func _on_animation_finished(anim_name: StringName) -> void:
	# 这个逻辑保持不变，由状态机来决定动画结束做什么
	# 为了让逻辑更清晰，可以让具体的状态来处理这个信号
	# 例如：state_machine.current_state.on_animation_finished(anim_name)
	print("[Character] 动画结束：%s" % anim_name)
	# 将信号委托给当前状态处理，如果状态机和当前状态存在且有该方法
	if state_machine and state_machine.current_state and state_machine.current_state.has_method("_on_animation_finished"):
		state_machine.current_state._on_animation_finished(anim_name)

		
# ## 公共方法 ##
func _on_died():
	print("[Character] 角色死亡信号收到喵！")
	if state_machine:
		state_machine.request_state_change("Death")
		
func get_facing_anim_direction() -> String:
	# 如果 _last_facing_direction 是 Vector2.ZERO，默认返回 "down" 方向的后缀
	if _last_facing_direction.is_equal_approx(Vector2.ZERO):
		return "_down" 

	# 判断优先级：通常左右方向的动画会优先于上下方向（如果同时按斜方向）
	if abs(_last_facing_direction.x) > abs(_last_facing_direction.y):
		if _last_facing_direction.x < 0:
			return "_left"
		else: # _last_facing_direction.x > 0
			return "_right"
	else: # _last_facing_direction.y 的绝对值更大或两者相等（纯上/下）
		if _last_facing_direction.y < 0:
			return "_up"
		else: # _last_facing_direction.y > 0
			return "_down"
