extends Node

signal selected(number : Number)
signal split(number: Number)
signal kill

signal lost
signal retry

signal round_started
signal round_ended
signal game_started
signal round_anouncement_finished
signal round_closure_finished

signal number_killed(is_godly : bool)

signal score_updated(score: int)
signal godly_updated(godly: int)
signal timer_updated(time: float, max_time: float)
