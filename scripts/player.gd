# Player.gd
# 继承自Character，但本身不含逻辑。它只是一个组件的容器。
# 在这个架构下，它的脚本非常干净，甚至只有一个 "pass" 也可以。
extends Character
class_name Player

# 这里是空的！所有的思考都交给状态机和状态了！
pass
