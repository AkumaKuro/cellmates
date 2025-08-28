class InstructionsScene extends Game:
	var font = ig.Font.new('media/04b03.font.png')
	var sfx = ig.Sound.new('media/audio/jump.*')

	var logo = ig.Image.new('media/instructionsLogo.png')

	func update():
		this.parent();

		if(ig.input.pressed('jump')):
			ig.currentLevel = 0;
			this.sfx.play();
			this.fireEvent('scene-complete', 'LevelScene');



	# This is a two player game
	# One player controls the heart with the mouse
	# click mouse button to change heart rate
	#
	# other player controls the player
	# arrow keys to move, X to jump
	# d-pad to move, A to jump


	func draw():
		this.parent();

		ig.system.context.fillStyle = 'orange';
		ig.system.context.fillRect(0, 0, ig.system.realWidth, ig.system.realHeight);

		this.logo.draw(20, 20);

		this.font.draw('How to play, you need two people!', ig.system.width / 2, 10, ig.Font.ALIGN.CENTER);

		var x = 65;
		this.font.draw('Move the heart with the mouse,', x, 34);
		this.font.draw('it shoots cells that help the player', x, 44);
		this.font.draw('left click to change heart rate', x, 54);

		this.font.draw('The heart has a set amount of blood', x, 78);

		this.font.draw('Collect these to refill blood', x, 124);

		if(Gamepad.getState(0)):
			this.font.draw('Move with the dpad, jump with A', x, 170);
		else:
			this.font.draw('Move with the arrow keys, jump with X', x, 170);


		this.font.draw('Reach the goal!', x, 214);

		this.font.draw('Press ' + ('A' if Gamepad.getState(0) else 'X') + ' to begin', ig.system.width - 90, ig.system.height - 10);
