
@export var pause_screen: Control
@export var music_player: AudioStreamPlayer

class MainGame extends Game:

	func _init() -> void:

		self._onSceneCompleteBound = self._onSceneComplete.bind(self);
		self._setScene(TitleScene);

	func _process() -> void:
		self.updateGamePad();

		if(ig.input.pressed('screenshot')):
			window.open(document.getElementsByTagName('canvas')[0].toDataURL());


		self.parent();
		if (ig.input.pressed('pause')):
			ig.paused = !ig.paused;
			if(ig.paused):
				ig.music.pause();
			else:
				ig.music.play();



		if (!ig.paused):
			this._currentScene.update();



	func draw():
		this.parent();
		this._currentScene.draw();

		if (ig.paused):
			pause_screen.show()



	func _setScene(SceneClass):
		if (this._currentScene):
			this._currentScene.un('scene-complete', this._onSceneCompleteBound);


		var scene = SceneClass.new(this._persistenceManager, this._session);
		scene.on('scene-complete', this._onSceneCompleteBound);

		this._currentScene = scene;


	func _onSceneComplete(nextSceneClassName):
		this._setScene(window[nextSceneClassName]);

func _ready():
	var scale = parseFloat(scale) if scale else 3;

	ig.main('#canvas', MainGame, 60, 320, 240, scale);
