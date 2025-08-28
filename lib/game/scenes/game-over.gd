class GameOverScene extends Game:

	var font = ig.Font.new('media/04b03.font.png')
	var logo = ig.Image.new('media/gameOverLogo.png')
	var death = ig.Sound.new('media/audio/death.*')

	func init():
		this.timer = ig.Timer.new(4);
		this.death.play();


	func update():
		this.parent();

		if(ig.input.pressed('jump') || this.timer.delta() > 0):
			var me = this;
			setTimeout(
				func():
					me.fireEvent('scene-complete', 'TitleScene');
			, 5);


	func draw():
		this.parent();

		ig.system.context.fillStyle = 'orange';
		ig.system.context.fillRect(0, 0, ig.system.realWidth, ig.system.realHeight);

		this.logo.draw(50, 10);

		this.font.draw('Game Over!', ig.system.width / 2, ig.system.height / 2 + 44, ig.Font.ALIGN.CENTER);
