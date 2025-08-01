# sandbag.gd
extends CharacterBody2D
class_name Sandbag

var FloatingTextScene = preload("res://scence/FloatingText2.tscn")

# 【引用所有零件】
@onready var state_machine: StateMachine = $StateMachine
@onready var anim_ctrl: AnimationController = $AnimationController
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health_comp: HealthComponent = $HealthComponent
@onready var health_bar = $WorldHealthBar # 依然保留引用，为了在死亡时隐藏它

# 【重要】为沙包创建一个独立的属性资源文件，就像你为Player做的一样
@export var stats_resource: CharacterStats

# 【新增】沙包没有复杂的朝向，但为了让AnimationController工作，我们提供一个默认值
var _last_facing_direction: Vector2 = Vector2.DOWN

func _ready():
	# 【连接神经中枢】
	# 1. 初始化生命组件
	health_comp.setup_stats(stats_resource)
	
	# 2. 连接“死亡”信号，当血量为0时，切换到死亡状态
	health_comp.died.connect(_on_died)
	
	# 3. 连接“受伤”信号，当Hurtbox被打中时，做两件事：
	#    a. 让HealthComponent处理伤害
	#    b. 让状态机切换到“受击”状态
	hurtbox.hit.connect(_on_hurtbox_hit)
	
	# 4. 初始化动画控制器和状态机
	anim_ctrl.setup_controllers(self, state_machine)
	anim_ctrl.animation_finished.connect(_on_animation_finished)
			
	var components_to_setup: Dictionary = {
		"character": self,
		"anim_ctrl": anim_ctrl,
		"health_comp": health_comp
	}
	state_machine.setup_controllers(components_to_setup)
	print("[Sandbag] 训练沙包已准备就绪喵！")

func _on_hurtbox_hit(hitbox: Hitbox):
	# a. 从 hitbox 获取伤害值，并命令生命组件处理伤害
	if health_comp and hitbox:
		var damage_value = hitbox.get_damage() # 从Hitbox获取伤害值 
		health_comp.apply_damage(damage_value) # 将 int 传递给 HealthComponent [cite: 5, 1]
	# b. 命令状态机切换到“受击”状态
	state_machine.request_state_change("Hit")
	
	show_floating_text("砰!")
	
func show_floating_text(onomatopoeia: String):
	var floating_text = FloatingTextScene.instantiate()
	
	# 在添加到场景树之前，就把所有“初始数据”准备好
	floating_text.text_to_display = onomatopoeia
	floating_text.global_position = self.global_position + Vector2(0, -10)
	
	# 添加到场景树，然后就不用管了。它会在下一帧自动执行自己的_ready()
	get_tree().get_root().add_child(floating_text)
	
# 当动画结束时，把信号转发给当前状态
func _on_animation_finished(anim_name: StringName):
	if state_machine.current_state and state_machine.current_state.has_method("_on_animation_finished"):
		state_machine.current_state._on_animation_finished(anim_name)

# 当收到死亡信号时，命令状态机切换
func _on_died():
	health_bar.hide()
	state_machine.request_state_change("Death")

# 【重要】为AnimationController提供它需要的方法，即使我们用不到
func get_facing_anim_direction() -> String:
	return "_down" # 沙包永远朝下一个方向
