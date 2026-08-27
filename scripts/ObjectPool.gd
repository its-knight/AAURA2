extends Node
class_name ObjectPool
## Generic object pool. Pre-instantiates a batch of a given scene and hands
## them out/back, so gameplay never calls instantiate()/queue_free() during
## the run (the #1 cause of GC hitches on mobile).

var scene: PackedScene
var _available: Array[Node] = []
var _parent: Node

func setup(p_scene: PackedScene, p_parent: Node, initial_size: int) -> void:
	scene = p_scene
	_parent = p_parent
	for i in range(initial_size):
		_available.append(_create_instance())

func _create_instance() -> Node:
	var inst: Node = scene.instantiate()
	inst.visible = false
	inst.set_process(false)
	inst.set_physics_process(false)
	if inst.has_method("set_pool_active"):
		inst.set_pool_active(false)
	_parent.add_child(inst)
	return inst

func acquire() -> Node:
	var inst: Node
	if _available.is_empty():
		inst = _create_instance()
	else:
		inst = _available.pop_back()
	inst.visible = true
	inst.set_process(true)
	inst.set_physics_process(true)
	if inst.has_method("set_pool_active"):
		inst.set_pool_active(true)
	return inst

func release(inst: Node) -> void:
	inst.visible = false
	inst.set_process(false)
	inst.set_physics_process(false)
	if inst.has_method("set_pool_active"):
		inst.set_pool_active(false)
	if not _available.has(inst):
		_available.append(inst)
