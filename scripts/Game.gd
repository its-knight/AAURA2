extends Node2D
## Game - the playable level scene. Responsible for:
##  - generating terrain, obstacles, coins, ramps, trees, clouds for the
##    current level (data pulled from LevelManager)
##  - reading input (tap = jump, hold = boost)
##  - driving the HUD, day/night background, pause/game-over/level-complete UI

const PlayerScene := preload("res://scenes/Player.tscn")
const ObstacleScene := preload("res://scenes/Obstacle.tscn")
const CoinScene := preload("res://scenes/Coin.tscn")
const RampScene := preload("res://scenes/Ramp.tscn")
const TreeScene := preload("res://scenes/PineTree.tscn")
const HUDScene := preload("res://scenes/HUD.tscn")
const PauseMenuScene := preload("res://scenes/PauseMenu.tscn")
const LevelCompleteScene := preload("res://scenes/LevelComplete.tscn")
const GameOverScene := preload("res://scenes/GameOverPopup.tscn")
const TerrainScene := preload("res://scenes/Terrain.tscn")
const CloudSceneReal := preload("res://scenes/Cloud.tscn")

@onready var world: Node2D = $World
@onready var terrain: StaticBody2D = $World/Terrain
@onready var camera: Camera2D = $Camera2D
@onready var sky: ColorRect = $SkyLayer/Sky
@onready var mountains_far: Node2D = $Parallax/MountainsFar
@onready var mountains_near: Node2D = $Parallax/MountainsNear
@onready var hud_layer: CanvasLayer = $HUDLayer
@onready var overlay_layer: CanvasLayer = $OverlayLayer

var player: CharacterBody2D
var hud: Control
var pause_menu: Control
var current_config: Dictionary
var level_number: int = 1

var obstacle_pool: ObjectPool
var coin_pool: ObjectPool
var ramp_pool: ObjectPool
var tree_pool: ObjectPool
var cloud_pool: ObjectPool

var _finish_x: float = 0.0
var _touch_active := false

func _ready() -> void:
	level_number = LevelManager.get_current_level_number()
	current_config = LevelManager.get_current_config()
	GameManager.reset_run()

	_setup_pools()
	_build_level()
	_spawn_player()
	_setup_hud()

	camera.set_target(player)
	SoundManager.play_music()

	GameManager.game_over.connect(_on_game_over)
	GameManager.level_finished.connect(_on_level_finished)

func _setup_pools() -> void:
	obstacle_pool = ObjectPool.new()
	obstacle_pool.setup(ObstacleScene, world, 12)
	coin_pool = ObjectPool.new()
	coin_pool.setup(CoinScene, world, 55)
	ramp_pool = ObjectPool.new()
	ramp_pool.setup(RampScene, world, 6)
	tree_pool = ObjectPool.new()
	tree_pool.setup(TreeScene, world, 20)
	cloud_pool = ObjectPool.new()
	cloud_pool.setup(CloudSceneReal, mountains_far, 8)

func _build_level() -> void:
	var length: float = current_config["length"]
	_finish_x = length
	terrain.build(length)

	_place_obstacles(length)
	_place_coins(length)
	_place_ramps(length)
	_place_trees(length)
	_place_clouds(length)
	_place_mountains(length)

func _place_obstacles(length: float) -> void:
	var count: int = current_config["obstacle_count"]
	var gap_min: float = current_config["gap_min"]
	var gap_max: float = current_config["gap_max"]
	var x: float = 500.0
	var sizes := [Obstacle.Size.SMALL, Obstacle.Size.MEDIUM, Obstacle.Size.LARGE]
	for i in range(count):
		if x > length - 300.0:
			break
		var obstacle: Node = obstacle_pool.acquire()
		var size_choice = sizes[randi() % sizes.size()]
		obstacle.configure(size_choice)
		var ground_y: float = terrain.get_ground_y(x)
		obstacle.position = Vector2(x, ground_y - 20)
		x += randf_range(gap_min, gap_max)

func _place_coins(length: float) -> void:
	var count: int = LevelManager.COINS_PER_LEVEL
	var spacing: float = length / float(count + 1)
	for i in range(count):
		var x: float = spacing * (i + 1) + randf_range(-30, 30)
		var ground_y: float = terrain.get_ground_y(x)
		var coin: Node = coin_pool.acquire()
		coin.position = Vector2(x, ground_y - 90 - randf_range(0, 40))

func _place_ramps(length: float) -> void:
	var ramp_count: int = 3 + level_number # more ramps on later levels
	var spacing: float = length / float(ramp_count + 1)
	for i in range(ramp_count):
		var x: float = spacing * (i + 1)
		var ground_y: float = terrain.get_ground_y(x)
		var ramp: Node = ramp_pool.acquire()
		ramp.position = Vector2(x, ground_y - 10)

func _place_trees(length: float) -> void:
	var tree_count: int = int(length / 260.0)
	for i in range(tree_count):
		var x: float = i * 260.0 + randf_range(-40, 40)
		var ground_y: float = terrain.get_ground_y(x)
		var tree: Node = tree_pool.acquire()
		tree.position = Vector2(x, ground_y)
		tree.z_index = -1

func _place_clouds(length: float) -> void:
	var cloud_count: int = 8
	for i in range(cloud_count):
		var cloud: Node = cloud_pool.acquire()
		cloud.position = Vector2(randf_range(0, length), randf_range(-450, -200))

func _place_mountains(length: float) -> void:
	# Two simple parallax mountain silhouettes, each a wide flat polygon strip.
	_build_mountain_layer(mountains_far, Color(0.29, 0.29, 0.46, 0.55), length, -300.0, 220.0)
	_build_mountain_layer(mountains_near, Color(0.22, 0.22, 0.38, 0.75), length, -220.0, 160.0)

func _build_mountain_layer(layer: Node2D, color: Color, length: float, base_y: float, amplitude: float) -> void:
	var poly := Polygon2D.new()
	var pts := PackedVector2Array()
	var step: float = 300.0
	var x: float = -800.0
	while x <= length + 800.0:
		var y: float = base_y - abs(sin(x * 0.0015)) * amplitude - randf_range(0, 20)
		pts.append(Vector2(x, y))
		x += step
	pts.append(Vector2(length + 800.0, 400.0))
	pts.append(Vector2(-800.0, 400.0))
	poly.polygon = pts
	poly.color = color
	layer.add_child(poly)

func _spawn_player() -> void:
	player = PlayerScene.instantiate()
	player.add_to_group("player")
	player.configure(current_config)
	player.position = Vector2(0, terrain.get_ground_y(0) - 40)
	world.add_child(player)
	player.crashed.connect(_on_player_crashed)
	player.jumped.connect(_on_player_jumped)
	player.landed.connect(_on_player_landed)

func _setup_hud() -> void:
	hud = HUDScene.instantiate()
	hud_layer.add_child(hud)
	hud.bind(level_number, current_config["length"])
	hud.pause_pressed.connect(toggle_pause)

func _process(delta: float) -> void:
	if player == null or GameManager.is_paused or GameManager.is_game_over or GameManager.is_level_complete:
		return

	var speed_ratio: float = (player.velocity.x - current_config["base_speed"]) / max(1.0, (current_config["max_speed"] - current_config["base_speed"]))
	GameManager.add_distance_score(player.velocity.x * delta, clamp(speed_ratio, 0.0, 1.0))

	var progress: float = clamp(player.global_position.x / _finish_x, 0.0, 1.0)
	sky.set_progress(progress)
	hud.update_progress(player.global_position.x)

	if player.global_position.x >= _finish_x:
		GameManager.trigger_level_complete()

func _unhandled_input(event: InputEvent) -> void:
	if GameManager.is_paused or GameManager.is_game_over or GameManager.is_level_complete:
		return
	if event is InputEventScreenTouch:
		_touch_active = event.pressed
		if event.pressed:
			player.try_jump()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_touch_active = event.pressed
		if event.pressed:
			player.try_jump()
	elif event.is_action_pressed("pause"):
		toggle_pause()

func _physics_process(_delta: float) -> void:
	if player:
		player.set_boosting(_touch_active)

func _on_player_jumped() -> void:
	pass

func _on_player_landed() -> void:
	GameManager.reset_combo()

func _on_player_crashed() -> void:
	GameManager.trigger_game_over()

func toggle_pause() -> void:
	if GameManager.is_game_over or GameManager.is_level_complete:
		return
	GameManager.is_paused = not GameManager.is_paused
	get_tree().paused = GameManager.is_paused
	if GameManager.is_paused:
		pause_menu = PauseMenuScene.instantiate()
		overlay_layer.add_child(pause_menu)
		pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		if pause_menu:
			pause_menu.queue_free()
			pause_menu = null

func _on_game_over() -> void:
	get_tree().paused = true
	var popup := GameOverScene.instantiate()
	popup.process_mode = Node.PROCESS_MODE_ALWAYS
	overlay_layer.add_child(popup)

func _on_level_finished() -> void:
	get_tree().paused = true
	SaveManager.set_high_score(level_number, GameManager.score)
	var stars: int = GameManager.compute_stars(level_number)
	SaveManager.set_stars(level_number, stars)
	SaveManager.unlock_next_level(level_number)

	var popup := LevelCompleteScene.instantiate()
	popup.process_mode = Node.PROCESS_MODE_ALWAYS
	overlay_layer.add_child(popup)
	popup.bind(GameManager.score, GameManager.coins_collected, stars, level_number)
