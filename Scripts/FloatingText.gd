extends Label3D

@export var float_speed := 0.5
@export var duration := 1.0

var lifetime := 0.0

func _process(delta):
	position.y += float_speed * delta
	lifetime += delta
	modulate.a = lerp(1.0, 0.0, lifetime / duration)
	if lifetime >= duration:
		queue_free()
