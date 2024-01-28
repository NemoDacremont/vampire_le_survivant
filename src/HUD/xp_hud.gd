extends CanvasLayer

@onready var xpBarNode: ProgressBar = $xpBar

func connect_hud_to_player(body: Node, body_signal: String):
	body.connect(body_signal, refresh_xp)

func refresh_xp(xp: float, xp_max: float, level: int):
	xpBarNode.max_value = xp_max
	xpBarNode.value = xp
	$level.text = str(level)
