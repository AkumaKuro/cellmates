
class EntityBaseMonster extends EntityBaseActor:
	var _wmIgnore = true
	var maxVel: Vector2 = Vector2(100, 100)
	var friction: Vector2 = Vector2(150, 0)
	var speed = 14
	var type = ig.Entity.TYPE.B
	var checkAgainst = ig.Entity.TYPE.A
	var collides = ig.Entity.COLLIDES.PASSIVE
	var collisionDamage =  1
	var lookAhead =  0
	var stayOnPlatform =  true
	func init(x, y, settings):

		parent(x, y, settings);
		spawner = settings.spawner;
		setupAnimation(settings.spriteOffset if settings.spriteOffset else 0);

	func update():

		parent();
		onUpdateAI();

	func onUpdateAI():

		if(stayOnPlatform):

			# near an edge? return!
			if (ig.game.collisionMap.getTile(
				pos.x + (-lookAhead if flip else size.x + lookAhead),
				pos.y + size.y + 1
			) == 0
				&& standing):

				flip = !flip;



		#TODO need to look into why monsters get stuck and switch back and forth on edges, maybe need a delay?
		var xdir = -1 if flip else 1;
		vel.x = speed * xdir;

		if(currentAnim):
			currentAnim.flip.x = flip;

	func handleMovementTrace(res):

		this.parent(res);
		# collision with a wall? return!
		if (res.collision.x):

			this.flip = !this.flip;


	func check(other):

		#Do a quick test to make sure the other object is visible
		if(other.visible):

			other.receiveDamage(this.collisionDamage, this);

			# Player is on top of monster so just keep walking in same direction
			if(other.pos.y > this.pos.y):
				return;

			# Test what side the player is on and flip direction based on that.
			this.flip = other.pos.x > this.pos.x
