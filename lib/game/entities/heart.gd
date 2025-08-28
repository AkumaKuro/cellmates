class_name Heart #extends Entity:
extends CharacterBody2D

var size: Vector2 = Vector2(24, 16)
var maxVel: Vector2 = Vector2(100, 200)

var dying: bool = false

var etype = 'heart'
var checkAgainst = 'ig.Entity.TYPE.A'

var slowPumpDuration = 2
var fastPumpDuration = 0.6
var dangerLevel = 0
var dangerMax = 5

var gravityFactor = 0
var maxCells = 20
var cellCount = 20
var collides = 'ig.Entity.COLLIDES.FIXED'
@export var flatline: AudioStreamPlayer
@export var sprite: AnimatedSprite2D

func _init(x, y, settings) -> void:

	var frameDuration = self.onePumpDuration / 2; #TODO animation speed modulation except for death anim

	self.releaseTimer = Timer.new();

	self.setMode(HeartMode.Slow);

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('toggle_heartrate'):
		toggleHeartRate()

func _process(delta: float) -> void:
	if(!self.dying):
		var mouse_position: Vector2 = get_viewport().get_mouse_position()
		self.pos.y = clamp(mouse_position.y, 0, 25 * ig.game.collisionMap.tilesize - self.size.y);


		if(self.releaseTimer.delta() > 0 && self.cellCount > 0):
			self.cellCount -= 1
			self.releaseTimer.reset();
			var cell = ig.game.spawnEntity(
				EntityCell, self.center.x + self.size.x / 2,
				self.center.y - 4, {
				red: randf() < 0.75
			});

			if(self.currentMode == HeartMode.Fast):
				cell.vel.x *= 1.5;



		var index = ceil(self.cellCount.map(0, self.maxCells, 0, self.allAnims.length - 1));
		self.currentAnim = self.allAnims[index];

		if(self.currentMode == HeartMode.Fast):
			self.dangerLevel += delta
		else:
			self.dangerLevel -= delta


		self.dangerLevel = self.dangerLevel.limit(0, self.dangerMax);
		if(self.dangerLevel == self.dangerMax):
			self.die();

	elif (self.currentAnim.loopCount > 0):
		heart_death.emit()


	self.pos.x = ig.game.screen.x + 9;
	self.parent();

signal heart_death

func die():
	if !dying:
		flatline.play()
		dying = true;
		sprite.play('heart_attack')

enum HeartMode {
	Slow,
	Fast
}


func toggleHeartRate():
	if currentMode == HeartMode.Fast:
		setMode(HeartMode.Slow);
	else:
		setMode(HeartMode.Fast);



func setMode(mode):
	if(self.currentMode != mode):
		self.currentMode = mode;
		self.onePumpDuration = self.fastPumpDuration if mode == HeartMode.Fast else self.slowPumpDuration;
		self.releaseTimer.set(self.onePumpDuration);

		self.allAnims.forEach(
			func(anim):
				anim.frameTime = self.onePumpDuration / 2;
		, self);



func check(other):
	self.playerStandingOn = other.etype == 'player' && other.canStandOnCell;

var heartRate :
	get: return round(60 / onePumpDuration);


var inDanger :
	get: return currentMode == HeartMode.Fast;




#EntityHeart.inject(MixinCenter);
