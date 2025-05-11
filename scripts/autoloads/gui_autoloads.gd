extends CanvasLayer

var gui_components = [
	"res://scenes/menu_escape.tscn"
]

var resolutions = {
	"2560x1440": Vector2i(2560,1440),
	"1920x1080": Vector2i(1920,1080),
	"1600x900": Vector2i(1600,900),
	"1440x900": Vector2i(1440,900),
	"1366x768": Vector2i(1366,768),
	"1280x720": Vector2i(1280,720),
	"1024x600": Vector2i(1024,600),
	"800x600": Vector2i(800,600)
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in gui_components:
		var new_scene = load(i).instantiate()
		add_child(new_scene)
		new_scene.hide()
		
func _input(_event):
	if Input.is_action_just_pressed("escape_menu"):
		var settings_menu = get_node("MenuEscape")
		settings_menu.visible = !settings_menu.visible
		if settings_menu.visible:
			settings_menu.update_button_values()
 

func center_window():
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(screen_center - window_size / 2) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
