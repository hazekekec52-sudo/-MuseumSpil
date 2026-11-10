
extends MeshInstance3D

const BREDDE = 512
const HOEJDE = 512
const RADIUS = 18

var billede: Image
var tekstur: ImageTexture


func _ready():
	# Start med et helt hvidt lærred.
	billede = Image.create(
		BREDDE, HOEJDE, false, Image.FORMAT_RGBA8
	)
	billede.fill(Color.WHITE)

	tekstur = ImageTexture.create_from_image(billede)

	# Gør det hvide lærred gennemsigtigt, hvor vi skyder.
	var materiale = StandardMaterial3D.new()
	materiale.albedo_texture = tekstur
	materiale.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	materiale.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	materiale.cull_mode = BaseMaterial3D.CULL_DISABLED

	material_override = materiale


func mal_paa_sted(verdenspunkt: Vector3):
	var lokalt = to_local(verdenspunkt)

	var u = (lokalt.x + 1.0) / 2.0
	var v = (1.0 - lokalt.y) / 2.0

	if u < 0 or u > 1 or v < 0 or v > 1:
		return

	var px = int(u * (BREDDE - 1))
	var py = int(v * (HOEJDE - 1))

	for y in range(maxi(0, py - RADIUS), mini(HOEJDE, py + RADIUS + 1)):
		for x in range(maxi(0, px - RADIUS), mini(BREDDE, px + RADIUS + 1)):
			if Vector2(x - px, y - py).length() <= RADIUS:
				billede.set_pixel(x, y, Color(1, 1, 1, 0))

	tekstur.update(billede)
