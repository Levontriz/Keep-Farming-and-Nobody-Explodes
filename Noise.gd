extends TileMapLayer


@export var map_width: int = 100
@export var map_height: int = 100
@export var world_seed: int = 12345 # Change this integer to generate different maps

var noise: FastNoiseLite

func _ready() -> void:
	generate_noise_map()

func generate_noise_map() -> void:
	# 1. Initialize the noise generator
	noise = FastNoiseLite.new()
	
	# 2. Apply your custom seed value
	noise.seed = world_seed
	
	# 3. Configure noise characteristics (Optional)
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX # Choose Simplex, Perlin, Cellular, etc.
	noise.frequency = 2                           # Higher values mean tighter, busier patterns
	
	# 4. Loop through grid coordinates to extract noise values
	for x in range(map_width):
		for y in range(map_height):
			# Get a decimal value typically ranging between -1.0 and 1.0
			var noise_val: float = noise.get_noise_2d(x, y)
			
			# Use the value to dictate your game world
			apply_noise_to_world((x - (map_width / 2)), (y - (map_height / 2)), noise_val)

func apply_noise_to_world(x: int, y: int, value: float) -> void:
	# Example thresholding for basic terrain generation
	var cell = Vector2i(x, y)
	if value < -0.5:
		set_cell(cell, 0, Vector2i(1,0))
	elif value < -0.3:
		set_cell(cell, 0, Vector2i(0,1))
	else:
		set_cell(cell, 0, Vector2i(0,0))
