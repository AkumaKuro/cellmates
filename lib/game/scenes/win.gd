class WinScene extends Game:

	func _init() -> void:
		self.timer = ig.Timer.new(2);


	func update() -> void:
		self.parent();

		if(ig.input.pressed('jump') || self.timer.delta() > 0):
			self.fireEvent('scene-complete', 'TitleScene');



	func draw() -> void:
		this.parent();
		this.font.draw('You guys rock!', ig.system.width / 2, ig.system.height / 2, ig.Font.ALIGN.CENTER);
