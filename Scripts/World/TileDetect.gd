extends TileMapLayer # Or extends TileMap
var terrain_set = 0
var tilled_terrain_id = 0


@onready var shrub_layer = $"../Shrub"

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos := to_local(get_global_mouse_position())
		var tile_pos := local_to_map(mouse_pos)

		if is_tilled(tile_pos):
			untill_soil(tile_pos)
		else:
			till_soil(tile_pos)

func is_tilled(cell: Vector2i) -> bool:
	var tile_data := get_cell_tile_data(cell)
	if tile_data == null:
		return false  # empty cell, nothing painted here
	return tile_data.terrain == tilled_terrain_id

func till_soil(cell: Vector2i):
	set_cells_terrain_connect([cell], terrain_set, tilled_terrain_id, false)
	shrub_layer.set_cell(cell)

func untill_soil(cell: Vector2i):
	set_cells_terrain_connect([cell], terrain_set, -1)
