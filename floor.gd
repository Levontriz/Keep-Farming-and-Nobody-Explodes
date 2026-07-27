extends TileMapLayer # Or extends TileMap

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos := to_local(get_global_mouse_position())
		var tile_pos := local_to_map(mouse_pos)

		var source_id := get_cell_source_id(tile_pos)
		if source_id != -1:
			print("Clicked tile at grid: ", tile_pos, " source: ", source_id, " atlas: ", get_cell_atlas_coords(tile_pos), " alternative: ", get_cell_alternative_tile(tile_pos))
