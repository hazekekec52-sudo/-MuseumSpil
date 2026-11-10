extends Node3D

## Enkel svævende museumsrobot, som holder sig tæt på spilleren.
@export var player_path: NodePath = NodePath("../Player")
@export var follow_distance: float = 1.8
@export var follow_height: float = 1.6
@export var move_speed: float = 3.5
@export var hover_height: float = 0.12

var player: Node3D
var elapsed := 0.0


func _ready() -> void:
	player = get_node_or_null(player_path) as Node3D
	_byg_robot()


func _process(delta: float) -> void:
	elapsed += delta
	if not is_instance_valid(player):
		player = get_node_or_null(player_path) as Node3D
		return

	var behind_player := player.global_transform.basis.z.normalized()
	var side_of_player := player.global_transform.basis.x.normalized()
	var target := player.global_position + behind_player * follow_distance + side_of_player * 0.8
	target.y = player.global_position.y + follow_height + sin(elapsed * 2.2) * hover_height

	var distance := global_position.distance_to(target)
	if distance > 0.08:
		global_position = global_position.move_toward(target, move_speed * delta)

	var look_target := player.global_position + Vector3.UP * 1.3
	if global_position.distance_squared_to(look_target) > 0.01:
		look_at(look_target, Vector3.UP)


func _byg_robot() -> void:
	var skal := _materiale(Color(0.78, 0.84, 0.9), 0.25)
	var lys_blaa := _materiale(Color(0.12, 0.8, 1.0), 0.15, true)
	var mork := _materiale(Color(0.06, 0.12, 0.18), 0.2)

	var krop := _mesh_node("Krop", SphereMesh.new(), skal)
	krop.position = Vector3(0, 0.12, 0)
	krop.scale = Vector3(0.42, 0.48, 0.34)
	add_child(krop)

	var kuppel := _mesh_node("Kuppel", SphereMesh.new(), skal)
	kuppel.position = Vector3(0, 0.48, 0)
	kuppel.scale = Vector3(0.31, 0.27, 0.3)
	add_child(kuppel)

	var visor := _mesh_node("Lysende øje", SphereMesh.new(), lys_blaa)
	visor.position = Vector3(0, 0.49, -0.255)
	visor.scale = Vector3(0.19, 0.105, 0.045)
	add_child(visor)

	for side in [-1.0, 1.0]:
		var øre := _mesh_node("Sideantenne", SphereMesh.new(), lys_blaa)
		øre.position = Vector3(side * 0.36, 0.12, 0)
		øre.scale = Vector3(0.08, 0.08, 0.08)
		add_child(øre)

	var ring_mesh := TorusMesh.new()
	ring_mesh.inner_radius = 0.34
	ring_mesh.outer_radius = 0.39
	var ring := _mesh_node("Svævering", ring_mesh, lys_blaa)
	ring.position.y = -0.28
	ring.rotation.x = deg_to_rad(90)
	add_child(ring)

	var lampe := _mesh_node("Bundlampe", SphereMesh.new(), mork)
	lampe.position = Vector3(0, -0.34, 0)
	lampe.scale = Vector3(0.15, 0.08, 0.15)
	add_child(lampe)

	var velkomst := Label3D.new()
	velkomst.name = "Velkomst"
	velkomst.text = "Hej! Jeg viser dig rundt."
	velkomst.font_size = 32
	velkomst.pixel_size = 0.005
	velkomst.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	velkomst.position = Vector3(0, 0.9, 0)
	velkomst.modulate = Color(0.85, 0.97, 1.0)
	add_child(velkomst)


func _mesh_node(node_name: String, mesh_resource: Mesh, material: Material) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = node_name
	node.mesh = mesh_resource
	node.material_override = material
	return node


func _materiale(color: Color, metallic: float, emissive: bool = false) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.metallic = metallic
	material.roughness = 0.3
	if emissive:
		material.emission_enabled = true
		material.emission = color
		material.emission_energy_multiplier = 1.5
	return material
