extends Weapon


func init(parent_position: Node):
	super(parent_position)
	_Fireball = load("res://src/attacks/player_attacks/fireball/pistol_bullet/pistol_bullet.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)

