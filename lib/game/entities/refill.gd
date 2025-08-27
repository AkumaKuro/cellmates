class EntityRefill extends Entity:

	var sfx = ig.Sound('media/audio/collect.*')
	var size: Vector2 = Vector2(8, 8)

	var etype = 'refill'

	var collides = ig.Entity.COLLIDES.NONE
	var checkAgainst = ig.Entity.TYPE.A
	var type = ig.Entity.TYPE.B
	var gravityFactor = 0

	var animSheet = ig.AnimationSheet('media/refill.png', 8, 8)

	func init(x, y, settings):
		this.parent(x, y, settings);
		this.addAnim('idle', 1, [0]);


	func check(other):
		if(other.isPlayer):
			this.fireEvent('refill-acquired');
			this.kill();
			this.sfx.play();
