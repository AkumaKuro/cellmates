
class EntityPlayer extends Entity:
	var size: Vector2 = Vector2(8, 14)
	var offset: Vector2 = Vector2(4, 2)
	var maxVel: Vector2 = Vector2(100, 200)
	var friction: Vector2 = Vector2(600, 0)
	var isPlayer: bool = true
	var visible: bool = true
	var etype: String = 'player'

	var type = ig.Entity.TYPE.A
	var checkAgainst = ig.Entity.TYPE.NONE

	var animSheet = ig.AnimationSheet.new('media/player.png', 16, 16)

	var flip = false
	var accelGround = 400
	var accelAir = 200
	var jump = 500
	var jumpSfx = ig.Sound.new('media/audio/jump.*')

	var health = 1

	var collides :
		get:
			if(this.__collides):
				return this.__collides;

			if (this.vel.y <= 0):
				return ig.Entity.COLLIDES.NONE;

			return ig.Entity.COLLIDES.PASSIVE;

		set(c):
			this.__collides = c;

	var canStandOnCell:
		get:
			return this.collides == ig.Entity.COLLIDES.PASSIVE && !this.standing;

	func _init(x, y, settings) -> void:
		this.parent(x, y, settings);

		this.addAnim('idle', 1, [0]);
		this.addAnim('run', 0.07, [0, 1, 2, 3, 4, 5]);
		this.addAnim('jump', 1, [9]);
		this.addAnim('fall', 0.4, [6, 7]);


	func update():
		var accel = this.accelGround if this.standing else this.accelAir
		if (ig.input.state('left')):
			this.accel.x = - accel;
			this.flip = true;

		elif (ig.input.state('right')):
			this.accel.x = accel;
			this.flip = false;

		else:
			this.accel.x = 0;


		if (this.standing && ig.input.pressed('jump')):
			this.vel.y = - this.jump;
			this.jumpSfx.play();


		if (this.vel.y < 0):
			this.currentAnim = this.anims.jump;

		elif (this.vel.y > 0):
			this.currentAnim = this.anims.fall;

		elif (this.vel.x != 0):
			this.currentAnim = this.anims.run;

		else:
			this.currentAnim = this.anims.idle;


		this.currentAnim.flip.x = this.flip;

		this.parent();

		if(this.standing):
			this.lastStandingPos = ig.copy(this.pos);



	func receiveDamage():
		this.fireEvent('player-death', this);
