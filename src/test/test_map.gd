extends TextureRect

@export var terrain_generator: BaseTerrainGenerator
@export var enable_elevation_lines: bool= true
@export var pixel_world_scale: float= 1.0
@export var height_cap: float= 3000.0
@export var elevation_line_steps: float= 50.0

var stored_height:= {}



func _ready() -> void:
	update.call_deferred()


func update()-> void:
	var min_height: float= 1000
	var max_height: float= 0
	var img_size: Vector2i= custom_minimum_size
	
	prints("Map Size", img_size)

	var image:= Image.create_empty(img_size.x, img_size.y, false, Image.FORMAT_RGB8)
	
	for x in img_size.x:
		for y in img_size.y:
			var pos:= Vector2i(x, y)
			var height= terrain_generator.get_height_at(Vector2(pos) * pixel_world_scale)
			stored_height[pos]= height
			if height > max_height:
				max_height= height
			elif height < min_height:
				min_height= height
			
			var pixel_color:= Color(.1, .1, .1)
			pixel_color= pixel_color.lerp(Color.WHITE, remap(height, 0, height_cap, 0.0, 1.0))

			image.set_pixelv(pos, pixel_color)

	prints("Min height", min_height)
	prints("Max height", max_height)

	if  enable_elevation_lines:
		var neighbors: Array[Vector2i]= [ Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT ]

		for x in range(1 , img_size.x - 1):
			for y in range(1, img_size.y - 1):
				var pos:= Vector2i(x, y)
				#var heights: Array[float]
				var height= stored_height[pos]
				if height < 10:
					continue
					
				for neighbor in neighbors:
					var neighbor_height: float= stored_height[pos + neighbor]
					if floor(neighbor_height / elevation_line_steps) != floor(height / elevation_line_steps):
						image.set_pixelv(pos, Color.BLUE.lerp(Color.WEB_GRAY, height / max_height))

	texture= ImageTexture.create_from_image(image)
