class_name MainGame# extends Game:
extends Node

@export var pause_screen: Control
@export var music_player: AudioStreamPlayer

@export var next_scene: PackedScene

var paused: bool = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&'screenshot'):
		take_screenshot()

	elif event.is_action_pressed(&'pause'):
		paused = !paused
		pause_screen.visible = paused
		if paused:
			music_player.stop()
		else:
			music_player.play()

func take_screenshot() -> void:
	printerr('Not implemented') #TODO



#
#func draw():
	#_currentScene.draw();
#
#
#func _setScene(SceneClass):
	#if (this._currentScene):
		#this._currentScene.un('scene-complete', this._onSceneCompleteBound);
#
#
	#var scene = SceneClass.new(this._persistenceManager, this._session);
	#scene.on('scene-complete', this._onSceneCompleteBound);
#
	#self._currentScene = scene;


func _onSceneComplete() -> void:
	get_tree().change_scene_to_packed(next_scene)
