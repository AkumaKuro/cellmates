class EntityGoalTrigger extends Entity:
	var type = ig.Entity.TYPE.B
	var checkAgainst = ig.Entity.TYPE.BOTH

	var size: Vector2 = Vector2(16, 32)

	var animSheet = ig.AnimationSheet.new('media/goal.png', 16, 32)

	func init(x, y, settings):
		this.parent(x, y, settings);

		this.addAnim('idle', 1, [0]);


	func check(other):
		if(other.isPlayer):
			this.fireEvent('player-made-it', this);
