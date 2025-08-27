
class MainGame extends Game:

	func _init() -> void:

		self._onSceneCompleteBound = self._onSceneComplete.bind(self);
		self._setScene(TitleScene);

		ig.music.add( 'media/audio/bg_music.*' );
		ig.music.volume = 0.5;


	func updateGamePad():
		var gamepad = Gamepad.getState(0);
		if(!gamepad):
			return;

		var mappings = [[ gamepad.dpadUp, ig.KEY.UP_ARROW ],
					[ gamepad.dpadDown, ig.KEY.DOWN_ARROW ],
					[ gamepad.dpadLeft, ig.KEY.LEFT_ARROW ],
					[ gamepad.dpadRight, ig.KEY.RIGHT_ARROW ],
					[ gamepad.start, ig.KEY.P ],
					[ gamepad.select, ig.KEY.S ],
					[ gamepad.faceButton0, ig.KEY.X ]];

		Gamepad.new().magic(gamepad, mappings);


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
			ig.system.context.save();
			ig.system.context.fillStyle = 'rgba(0, 0, 0, 0.4)';
			ig.system.context.fillRect(0, 0, ig.system.realWidth, ig.system.realHeight);
			ig.system.context.restore();
			this.font.draw('paused', ig.system.width / 2, ig.system.height / 2, ig.Font.ALIGN.CENTER);



	func _setScene(SceneClass):
		if (this._currentScene):
			this._currentScene.un('scene-complete', this._onSceneCompleteBound);


		var scene = SceneClass.new(this._persistenceManager, this._session);
		scene.on('scene-complete', this._onSceneCompleteBound);

		this._currentScene = scene;


	func _onSceneComplete(nextSceneClassName):
		this._setScene(window[nextSceneClassName]);



func getUrlParam(name) -> void:
	name = name.replace("/[[]/", "\\[").replace("/[]]/", "\\]");
	var regexS = "[\\?&]" + name + "=([^&#]*)";
	var regex = RegExp.new(regexS);
	var results = regex.exec(window.location.href);
	if (results == null):
		return "";
	else:
		return results[1];


var scale = getUrlParam('scale');

func _ready():
	scale = parseFloat(scale) if scale else 3;

	ig.main('#canvas', MainGame, 60, 320, 240, scale);
