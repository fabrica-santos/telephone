extends Node

var call_times: Array = [240, 120, 60, 30, 15, 7.5, 3.25, 1.0]
var time_randomness: Array = [60, 30, 15, 7.5, 3.25, 1.0]
var game_difficulty: int = 0
var refusal_counter: int = 0
var phone_app: Node = null
var mail_app: Node = null
var quest_log: Array = []

@onready var call_wait: Timer = $CallWait




var call_quests_fixed: Dictionary = {
}

var character_templates: Dictionary = {
	
	"ms_ednea": {
		"picture_path": "",
		"name": "Sra. Edinéia",
		"age": "60 e poucos"
	}

}

func _ready() -> void:
	var call_quests_random: Dictionary = JSON.parse_string((FileAccess.open("res://scripts/quests_random.json", FileAccess.READ)).get_as_text())

	var chosen_random: float = time_randomness.pick_random()
	call_wait.wait_time = call_times[game_difficulty] + randf_range(-chosen_random, chosen_random)
	call_wait.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func build_problem() -> void:
	pass

func _on_timer_timeout() -> void:
	var chosen_random: float = time_randomness.pick_random()
	call_wait.wait_time = call_times[game_difficulty] + randf_range(-chosen_random / 2.0, chosen_random)
	call_wait.start()
