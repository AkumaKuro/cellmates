class EntityCell extends Entity:

	var size: Vector2 = Vector2(16, 8)


	var maxVel: Vector2 = Vector2(500, 200)

	var vel: Vector2 = Vector2(35, 0)

	var standingCount: float = 0
	var standingDuration: float = 5

	var gravityFactor: float = 0
	var collides = ig.Entity.COLLIDES.FIXED
	var checkAgainst = ig.Entity.TYPE.BOTH
	var type = ig.Entity.TYPE.B
	var etype = 'cell'
	var collideIgnoreSameType: bool = true

	var animSheet = ig.AnimationSheet.new('media/cells.png', 16, 8)

	func _init(x, y, settings) -> void:
		this.parent(x, y, settings);

		if (self.red):
			self.floatVel = - 10;
			self.addAnim('idle', 1, [0]);
			self.addAnim('death', 0.1, [5, 6], true);
			self.addAnim('dyingWarning', 0.2, [15, 16]);
		else:
			self.floatVel = 10;
			self.addAnim('idle', 1, [1]);
			self.addAnim('death', 0.1, [10, 11], true);
			self.addAnim('dyingWarning', 0.2, [20, 21]);



	func update():
		this.parent();

		if (this.pos.x > ig.game.screen.x + ig.system.width):
			this.kill();


		if (this.dying && this.currentAnim.loopCount > 0):
			this.kill();


		if (!this.dying):
			if (this.standingCount >= this.standingDuration * 0.5):
				this.currentAnim = this.anims.dyingWarning;
			else:
				this.currentAnim = this.anims.idle;




	func die():
		if (!this.dying):
			this.dying = true;
			this.currentAnim = this.anims.death;
			this.currentAnim.rewind();
			this.collides = ig.Entity.COLLIDES.NONE;



	func handleMovementTrace(res):
		# This completely ignores the trace result (res) and always
		# moves the entity according to its velocity
		this.pos.x += this.vel.x * ig.system.tick;
		this.pos.y += this.vel.y * ig.system.tick;


	func check(other):
		if (other.canStandOnCell):
			this.pos.y += this.floatVel * ig.system.tick;

		if(other.etype == 'monster'):
			other.die();
