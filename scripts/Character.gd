# Character.gd 
# 融合了状态机和Hurtbox碰撞系统的最终角色模板
extends CharacterBody2D
class_name Character

# ## 属性与组件 ##
@onready var state_machine: Node = $StateMachine
@onready var anim_player: AnimationPlayer = $AnimationPlayer
# 【新增】组件引用：引用我们之前设计的“护甲片”
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health_comp: HealthComponent = $HealthComponent
var _last_facing_direction = "_down"

# ## Godot 方法 ##
func _ready():
	if health_comp == null:
		push_error("[Character] HealthComponent 未找到喵！")
		return
		
	# 自动绑定动画结束回调
	if not anim_player.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		anim_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	if health_comp:
		health_comp.died.connect(Callable(self, "_on_died"))
		health_comp.hp_changed.connect(Callable(self, "_on_hp_changed_in_ui"))
	
	
	# 【新增】连接Hurtbox信号：让角色能“感知”到自己被攻击
	# 这是将碰撞系统接入你状态机架构的“发动机”！
	if hurtbox:
		hurtbox.hit.connect(on_hurtbox_hit)
	
	if state_machine:
		state_machine.request_state_change("Idle")
	else:
		push_error("【致命错误】喵！Character的_ready中，state_machine是Nil！无法设置初始状态喵！")

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
	if anim_name == "attack":
		state_machine.request_state_change("Idle")

		
# ## 公共方法 ##

# 播放动画的辅助函数，保持不变
func play_anim(anim_name: String):
	if anim_player.current_animation != anim_name:
		anim_player.play(anim_name)

func _on_died():
	print("[Character] 角色死亡信号收到喵！")
