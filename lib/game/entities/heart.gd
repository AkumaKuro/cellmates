
class EntityHeart extends Entity:
	var size: Vector2 = Vector2(24, 16)
	var maxVel: Vector2 = Vector2(100, 200)


	var etype = 'heart'
	var checkAgainst = ig.Entity.TYPE.A

	var slowPumpDuration = 2
	var fastPumpDuration = 0.6
	var dangerLevel = 0
	var dangerMax = 5

	var gravityFactor = 0
	var maxCells = 20
	var cellCount = 20
	var collides = ig.Entity.COLLIDES.FIXED
	var flatline = ig.Sound.new('media/audio/flatline.*')


	var animSheet = ig.AnimationSheet.new('media/heart.png', 24, 16)

	func _init(x, y, settings) -> void:
		self.parent(x, y, settings);

		var frameDuration = self.onePumpDuration / 2;
		self.addAnim('full', frameDuration, [1,0]);
		self.addAnim('down1', frameDuration, [3,2]);
		self.addAnim('down2', frameDuration, [5,4]);
		self.addAnim('down3', frameDuration, [7,6]);
		self.addAnim('down4', frameDuration, [9,8]);
		self.addAnim('empty', frameDuration, [11,10]);

		self.addAnim('heartAttack', 0.2, [12, 13], true);

		self.allAnims = [
			self.anims.empty,
			self.anims.down4,
			self.anims.down3,
			self.anims.down2,
			self.anims.down1,
			self.anims.full
		];

		self.releaseTimer = ig.Timer.new();

		self.setMode('slow');


	func update():
		if(!self.dying):
			self.pos.y = ig.input.mouse.y.limit(0, 25 * ig.game.collisionMap.tilesize - self.size.y);

			if(ig.input.pressed('toggle-heartrate')):
				self.toggleHeartRate();


			if(self.releaseTimer.delta() > 0 && self.cellCount > 0):
				this.cellCount -= 1
				this.releaseTimer.reset();
				var cell = ig.game.spawnEntity(
					EntityCell, this.center.x + this.size.x / 2,
					this.center.y - 4, {
					red: Math.random() < 0.75
				});

				if(this.currentMode == 'fast'):
					cell.vel.x *= 1.5;



			var index = Math.ceil(this.cellCount.map(0, this.maxCells, 0, this.allAnims.length - 1));
			this.currentAnim = this.allAnims[index];

			if(this.currentMode == 'fast'):
				this.dangerLevel += ig.system.tick;
			else:
				this.dangerLevel -= ig.system.tick;


			this.dangerLevel = this.dangerLevel.limit(0, this.dangerMax);
			if(this.dangerLevel == this.dangerMax):
				this.die();

		elif (this.currentAnim.loopCount > 0):
			this.fireEvent('heart-death', this);


		this.pos.x = ig.game.screen.x + 9;
		this.parent();


	func die():
		if(!this.dying):
			this.flatline.play();
			this.dying = true;
			this.currentAnim = this.anims.heartAttack;
			this.currentAnim.rewind();



	func toggleHeartRate():
		if(this.currentMode == 'fast'):
			this.setMode('slow');
		else:
			this.setMode('fast');



	func setMode(mode):
		if(self.currentMode != mode):
			self.currentMode = mode;
			self.onePumpDuration = self.fastPumpDuration if mode == 'fast' else self.slowPumpDuration;
			self.releaseTimer.set(self.onePumpDuration);

			self.allAnims.forEach(
				func(anim):
					anim.frameTime = self.onePumpDuration / 2;
			, self);



	func check(other):
		self.playerStandingOn = other.etype == 'player' && other.canStandOnCell;

	var heartRate :
		get: return Math.round(60 / this.onePumpDuration);


	var inDanger :
		get: return this.currentMode == 'fast';




#EntityHeart.inject(MixinCenter);
