
var levels = levels || [];

func _init() -> void:
	levels.push(LevelLevel1);

class LevelScene extends Node: # Inherits Game
	var gravity = 300

	var font = ig.Font.new('media/04b03.font.png')
	var redFont = ig.Font.new('media/redFont.png')
	var oneup = ig.Image.new('media/1up.png')

	var vel: Vector2 = Vector2(20, 0)
	@export var player: Player


	func init():
		this.loadLevel(ig.copy(ig.levels[ig.currentLevel]));

		this.goal = this.getEntitiesByType(EntityGoalTrigger)[0];

		this.goal.on('player-made-it', this.onPlayerMadeIt.bind(this));

		this.player.on('player-death', this.onPlayerDeath.bind(this));

		this.heart = this.getEntitiesByType(EntityHeart)[0];
		this.heart.on('heart-death', this.onHeartDeath.bind(this));

		this.dangerMeter = this.getEntitiesByType(EntityDangerMeter)[0];
		this.dangerMeter.heart = this.heart;

		var onRefillAcquired = this.onRefillAcquired.bind(this);
		self.getEntitiesByType(EntityRefill).forEach(
			func(refill):
				refill.on('refill-acquired', onRefillAcquired);
		);

		ig.music.play();


	func getTileAtPixelPosition(px, py):
		var ts = this.collisionMap.tilesize;

		var tx = (px / ts) | 0;
		var ty = (py / ts) | 0;

		return { x: tx, y: ty };


	func onPlayerDeath():
		ig.numLives -= 1

		if(ig.numLives == 0):
			ig.music.stop();
			this.fireEvent('scene-complete', 'GameOverScene');
		else:
			this.player.pos = this.player.lastStandingPos;
			var tile = this.getTileAtPixelPosition(this.player.pos.x, this.player.pos.y);
			this.player.pos.x = tile.x * this.collisionMap.tilesize + this.collisionMap.tilesize / 2;

			if(this.player.pos.x < this.screen.x):
				this.screen.x = Math.max(this.player.pos.x - 30, 0);




	func onHeartDeath():
		this.heartDead = true;
		this.heart.kill();
		this.dangerMeter.kill();


	func onRefillAcquired():
		this.heart.cellCount  = (this.heart.cellCount + 10).limit(0, this.heart.maxCells);


	func onPlayerMadeIt():
		this.madeIt = true;
		ig.music.stop();

		var me = this;
		setTimeout(func():
			ig.currentLevel += 1
			if(ig.currentLevel >= ig.levels.length):
				me.fireEvent('scene-complete', 'WinScene');
			else:
				me.fireEvent('scene-complete', 'LevelScene');

		, 1000);


	func update():
		this.heart.playerStandingOn = false;
		this.setCellsLastY();

		var screenDelta = this.vel.x * ig.system.tick;
		this.screen.x += screenDelta;
		this.parent();

		this.checkForStandingOnCells();

		if(this.heart.playerStandingOn):
			this.lastWasStandingOnHeart = true;
			this.heart.setMode('fast');
			this.player.pos.x += screenDelta;
		else:
			if(this.lastWasStandingOnHeart):
				this.lastWasStandingOnHeart = false;
				this.heart.setMode('slow');



		this.player.pos.x = Math.max(this.player.pos.x, this.screen.x);

		if (this.player.pos.y > this.height):
			this.onPlayerDeath();



	func getCells():
		return this.getEntitiesByType(EntityCell);


	func setCellsLastY():
		var cells = this.getCells();

		for i: int in range(cells.length):
			cells[i].lastY = cells[i].pos.y;



	func checkForStandingOnCells():
		var cells = this.getCells();

		for i: int in range(cells.length):
			var cell = cells[i];
			if(cell.lastY != cell.pos.y):
				cell.standingCount += ig.system.tick;
			else:
				cell.standingCount = 0;


			if(cell.standingCount >= cell.standingDuration):
				cell.die();




	func drawHeartRate():
		var font = this.redFont if this.heart.inDanger else this.font;
		var x = 10;

		if(this.heart.inDanger):
			x += Math.random() * 2;


		font.draw("heart rate: " + this.heart.heartRate, x, ig.system.height - 20);


	func drawNumberOfLives():
		var x = 10;
		for i: int in range(ig.numLives):
			this.oneup.draw(x, ig.system.height - 10);
			x += 10;



	func draw():
		this.parent();

		if(!this.heartDead):
			this.drawHeartRate();


		this.drawNumberOfLives();

		if(this.madeIt):
			this.font.draw('good job!', 50, 80);



	func getMap(name):
		return this.backgroundMaps.filter(
			func(m):
				return m.name == name
		)[0];

	var height:
		get:
			var map = this.getMap('platforms');
			return (map && (map.height * this.collisionMap.tilesize)) || 0;
