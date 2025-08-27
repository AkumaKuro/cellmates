class EntityBaseActor extends Entity:
	var _wmIgnore = true
	var visible = true
	var weapon = 0
	var activeWeapon = "none"
	var startPosition = null
	var invincible = false
	var invincibleDelay = 2
	var captionTimer = null
	var healthMax = 10
	var health = 10
	var markedForDeath = false
	var fallDistance = 0
	var maxFallDistance = 10000
	var shotPressed = false
	var fireDelay = null
	var fireRate = 0
	var bloodColorOffset = 0
	var equipment = []
	func init(x, y, settings):

		this.parent(x, y, settings);
		this.spawner = settings.spawner;
		#TODO need to figure out if we should call this here?
		this.setupAnimation(settings.spriteOffset if settings.spriteOffset else 0);
		this.startPosition = {x:x, y:y};
		this.captionTimer = ig.Timer.new();
		this.fireDelay = ig.Timer.new();

	func setupAnimation(offset):
		pass

	func receiveDamage(value, from):

		if (this.invincible || !this.visible):
			return;

		this.parent(value, from);

		if (this.health > 0):

			this.spawnParticles(2);


	func kill(noAnimation):

		this.parent();
		#TODO need to rename all this to make more sense
		if (!noAnimation):

			this.markedForDeath = true;
			this.onDeathAnimation();

		else:

			this.onKill();


	func onKill():

		#Handler for when the entity is killed
		pass

	func onDeathAnimation():

		#ig.game.spawnEntity(EntityDeathExplosion, this.pos.x, this.pos.y, {colorOffset: this.bloodColorOffset, callBack:this.onKill});

		#TODO need to think through this better

		pass
	func outOfBounds():

		this.kill(true);

	func collideWith(other, axis):


		# check for crushing damage from a moving platform (or any FIXED entity)
		if (other.collides == ig.Entity.COLLIDES.FIXED && this.touches(other)):

			# we're still overlapping, but by how much?
			var overlap;
			var size;
			if (axis == 'y'):

				size = this.size.y;
				if (this.pos.y < other.pos.y):
					overlap = this.pos.y + this.size.y - other.pos.y;
				else:
					overlap = this.pos.y - (other.pos.y + other.size.y);
			else:

				size = this.size.x;
				if (this.pos.x < other.pos.x):
					overlap = this.pos.x + this.size.x - other.pos.x;
				else:
					overlap = this.pos.x - (other.pos.x + other.size.x);

			overlap = Math.abs(overlap);

			# overlapping by more than 1/2 of our size?
			if (overlap > 3):

				# we're being crushed - this is damage per-frame, so not 100% the same at different frame rates
				this.kill();



	func spawnParticles(total):

		#for (var i = 0; i < total; i++)
			#ig.game.spawnEntity(EntityDeathExplosionParticle, this.pos.x, this.pos.y, {colorOffset:this.bloodColorOffset});
		pass

	func makeInvincible():

		this.invincible = true;
		this.captionTimer.reset();
		#this.collides = ig.Entity.COLLIDES.NONE;

	func equip(target):
		this.equipment.push(target);

	func update():

		#TODO maybe we need to add invincible to draw or consolidate the two
		if (this.captionTimer.delta() > this.invincibleDelay):

			this.invincible = false;
			if(this.currentAnim):
				this.currentAnim.alpha = 1;

			#Reset active collision setting
			#this.collides = ig.Entity.COLLIDES.ACTIVE;


		if (this.visible):
			this.updateAnimation();

		this.parent();

	func updateAnimation():
		pass
		#Replace with logic to set the correct animation

	func draw():


		# Exit draw call if the entity is not visible
		if (!this.visible):
			return;

		#TODO do we really need this?
		if(this.currentAnim):

			if (!this.visible):
				this.currentAnim.alpha = 0;
			else:
				this.currentAnim.alpha = 1;


		if (this.invincible):
			this.currentAnim.alpha = this.captionTimer.delta() / this.invincibleDelay * 1 + .2;

		this.parent();

	func handleMovementTrace(res):


		this.parent(res);

		#TODO need to add some kind of check to make sure we are not calling this too many times
		if ((res.collision.y) && (this.fallDistance > this.maxFallDistance)):

			this.onFallToDeath();


	func onFallToDeath():

		this.kill();

	func repel(direction, force):
		pass
