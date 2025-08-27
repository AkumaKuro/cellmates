class EntityMonster extends EntityBaseMonster:
	var _wmIgnore = false
	var size: Vector2 = Vector2(8, 8)
	var etype = 'monster'

	var animSheet = ig.AnimationSheet.new('media/monster.png', 8, 8)

	func init(x, y, settings):
		this.parent(x, y, settings);


	func setupAnimation():
		this.addAnim('idle', 0.3, [0,1,2]);


	func die():
		# TODO: death animation
		this.kill();


	func check(other):
		this.parent(other);
		this.die();
