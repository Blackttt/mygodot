extends Node
class_name State

var state_machine: Node = null
var character: CharacterBody2D = null

func enter(payload: Dictionary = {}): pass
func exit(): pass
func update(delta: float): pass
func update_data(payload: Dictionary = {}): pass
func physics_update(delta: float): pass
