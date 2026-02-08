extends Node

@export var in_combat : bool
var last_combat : bool

@export var ChillMusicPlayer : AudioStreamPlayer
@export var CombatMusicPlayer : AudioStreamPlayer

@export var combat_music_target_volume : float = 0
@export var chill_music_target_volume : float = 0
var mute_music_target : float = -80
@export var music_fade_in_speed : float = 10
@export var music_fade_out_speed : float = 1

func _process(delta: float) -> void:
	#if last_combat != in_combat :
	
	if in_combat :
		CombatMusicPlayer.volume_db = lerpf(
			CombatMusicPlayer.volume_db,
			combat_music_target_volume,
			music_fade_in_speed * delta)
		
		ChillMusicPlayer.volume_db = lerpf(
			ChillMusicPlayer.volume_db,
			mute_music_target,
			music_fade_out_speed * delta)
		
	else :
		CombatMusicPlayer.volume_db = lerpf(
			CombatMusicPlayer.volume_db,
			mute_music_target,
			music_fade_out_speed * delta)
		
		ChillMusicPlayer.volume_db = lerpf(
			ChillMusicPlayer.volume_db,
			chill_music_target_volume,
			music_fade_in_speed * delta)
	
	
	
	last_combat = in_combat
