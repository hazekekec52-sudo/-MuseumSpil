
extends Area3D

const HASTIGHED = 35.0

var retning: Vector3 = Vector3.ZERO


func start(start_position: Vector3, flyve_retning: Vector3) -> void:
	global_position = start_position
	retning = flyve_retning.normalized()


func _physics_process(delta: float) -> void:
	if retning == Vector3.ZERO:
		return

	var fra = global_position
	var til = fra + retning * HASTIGHED * delta

	var forespoergsel = PhysicsRayQueryParameters3D.create(fra, til)
	var resultat = get_world_3d().direct_space_state.intersect_ray(forespoergsel)

	if not resultat.is_empty():
		var node = resultat["collider"]

		while node != null:
			if node.has_method("mal_paa_sted"):
				node.mal_paa_sted(resultat["position"])
				break
			node = node.get_parent()

		queue_free()
		return

	global_position = til
