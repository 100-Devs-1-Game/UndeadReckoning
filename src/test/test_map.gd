extends ColorRect

@export var terrain_generator: BaseTerrainGenerator
@export var enable_elevation_lines: bool= true
@export var pixel_world_scale: float= 1.0
@export var max_height: float= 3000.0
@export var elevation_line_steps: float= 50.0

var stored_height:= {}


func _draw() -> void:
	var min_height: float= 1000
	var max_height: float= 0
	
	prints("Map Size", custom_minimum_size)
	
	for x in custom_minimum_size.x:
		for y in custom_minimum_size.y:
			var pos:= Vector2i(x, y)
			var height= terrain_generator.get_height_at(Vector2(pos) * pixel_world_scale)
			stored_height[pos]= height
			if height > max_height:
				max_height= height
			elif height < min_height:
				min_height= height
			
			var pixel_color:= Color(.1, .1, .1)
			pixel_color= pixel_color.lerp(Color.WHITE, remap(height, 0, max_height, 0.0, 1.0))
			
			#var rgb_clamp:= clampf(pixel_color.r, 0.0, 1.0)
			#pixel_color= Color(rgb_clamp, rgb_clamp, rgb_clamp)
			#var height_rgb: float= height / max_height
			#var pixel_color:= Color(height_rgb, height_rgb, height_rgb)
			draw_rect(Rect2(pos, Vector2.ONE), pixel_color)

	prints("Min height", min_height)
	prints("Max height", max_height)

	if not enable_elevation_lines:
		return

	var neighbors: Array[Vector2i]= [ Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT ]

	for x in range(1 , custom_minimum_size.x - 1):
		for y in range(1, custom_minimum_size.y - 1):
			var pos:= Vector2i(x, y)
			#var heights: Array[float]
			var height= stored_height[pos]
			if height < 10:
				continue
				
			for neighbor in neighbors:
				var neighbor_height: float= stored_height[pos + neighbor]
				if floor(neighbor_height / elevation_line_steps) != floor(height / elevation_line_steps):
					draw_rect(Rect2(pos, Vector2.ONE), Color.BLUE.lerp(Color.WHITE, height / max_height))
