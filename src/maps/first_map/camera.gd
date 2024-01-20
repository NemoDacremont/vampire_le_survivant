extends Camera2D

@export var tracking: bool
var body_tracked: Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if tracking:
		self.position = body_tracked.position

func track(body: Node2D) -> void:
	body_tracked = body
	tracking = true
