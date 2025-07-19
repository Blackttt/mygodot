extends CharacterBody2D
class_name CharacterBase

@export var stats: CharacterStats
@onready var state_machine: Node = $StateMachine
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	if stats == null:
		stats = CharacterStats.new()
	print("[CharacterBase] 初始化，当前HP：%d" % stats.current_hp)
	
	# 自动绑定动画结束回调
	var anim_player = get_node("AnimationPlayer")
	if not anim_player.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		anim_player.connect("animation_finished", Callable(self, "_on_animation_finished"))



func apply_damage(amount: int):
	stats.take_damage(amount)
	if stats.current_hp <= 0:
		print("[CharacterBase] HP为0，请求切换死亡状态")
		state_machine.request_state_change("Death")

func play_anim(anim_name: String):
	anim_player.play(anim_name)


func _on_animation_finished(anim_name: StringName) -> void:
	print("[CharacterBase] 动画结束：%s" % anim_name)
	if anim_name == "attack":
		state_machine.request_state_change("Idle")
