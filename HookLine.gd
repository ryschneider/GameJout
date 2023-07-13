extends Line2D

@onready var Player = get_node("/root/Node2D/Player")
@onready var Hook = get_node("/root/Node2D/Hook")

func _ready():
	width = 0.3
	default_color = Color.RED

func _physics_process(delta):
	clear_points()
	if Hook.is_visible():
		var dif = Hook.ropeLength - (Hook.global_position - Player.global_position).length()
		default_color = lerp(Color.RED, Color.YELLOW, dif * 0.03)
		add_point(Hook.global_position)
		add_point(Player.global_position)
