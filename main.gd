extends Node3D

@onready var light1: Light3D = $Light1
@onready var light2: Light3D = $Light2
@onready var light3: Light3D = $Light3
@onready var world_env: WorldEnvironment = $WorldEnvironment
@onready var cam1: Camera3D = $CameraRig/Camera1
@onready var cam2: Camera3D = $CameraRig/Camera2
@onready var cam3: Camera3D = $CameraRig/Camera3

var _sky_on := true

func _ready():
	cam1.current = true
	world_env.environment.ssao_enabled = false
	world_env.environment.ssao_radius = 1.5
	world_env.environment.ssao_intensity = 2.0

func _input(event):
	if not (event is InputEventKey and event.pressed):
		return
	match event.keycode:
		KEY_1: light1.visible = not light1.visible
		KEY_2: light2.visible = not light2.visible
		KEY_3: light3.visible = not light3.visible
		KEY_O:
			world_env.environment.ssao_enabled = not world_env.environment.ssao_enabled
		KEY_E:
			_sky_on = not _sky_on
			if _sky_on:
				world_env.environment.background_mode = Environment.BG_SKY
				world_env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
			else:
				world_env.environment.background_mode = Environment.BG_COLOR
				world_env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
		KEY_F1: _switch_camera(1)
		KEY_F2: _switch_camera(2)
		KEY_F3: _switch_camera(3)
		KEY_ESCAPE:
			if cam3.active:
				cam3.deactivate()

func _switch_camera(n: int):
	cam3.deactivate()
	cam1.current = false
	cam2.current = false
	cam3.current = false
	match n:
		1: cam1.current = true
		2: cam2.current = true
		3:
			cam3.current = true
			cam3.activate()
