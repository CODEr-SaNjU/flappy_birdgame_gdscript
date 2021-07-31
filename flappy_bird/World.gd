extends Node2D

onready var hud = $HUD
onready var obstacle_spawner = $ObstacleSpawner
onready var ground = $Ground
onready var menulayer = $MenuLayer

const SAVE_FILE_PATH = "user://savedata.save"

var score=0 setget set_score
var highscore = 0
func _ready():
	obstacle_spawner.connect("obstacle_created",self,"_on_obstacle_created")
	load_highscore()

func new_game():
	self.score = 0
	obstacle_spawner.start()

func player_score():
	self.score += 1
	

func set_score(new_score):
	score = new_score
	hud.update_score(score)

func _on_obstacle_created(obs):
	obs.connect("score",self,"player_score")
	

func _on_DeathZone_body_entered(body):
	if body is player:
		if body.has_method("die"):
			body.die()


func _on_player_died() -> void:
	game_over()
	
func game_over():
	obstacle_spawner.stop()
	ground.get_node("AnimationPlayer").stop()
	get_tree().call_group("obstacles", "set_physics_process", false)
	
	if score > highscore:
		highscore = score
		save_highscore()
	menulayer.init_game_over_menu(score, highscore)



func _on_MenuLayer_start_game() -> void:
	new_game()
	
	
func save_highscore():
	var save_data = File.new()
	save_data.open(SAVE_FILE_PATH,File.WRITE)
	save_data.store_var(highscore)
	save_data.close()
	
	
func load_highscore():
	var save_data = File.new()
	if save_data.file_exists(SAVE_FILE_PATH):
		save_data.open(SAVE_FILE_PATH, File.READ)
		highscore = save_data.get_var()
		save_data.close()











