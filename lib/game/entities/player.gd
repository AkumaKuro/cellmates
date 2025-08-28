class_name EntityPlayer
extends CharacterBody2D

var size: Vector2 = Vector2(8, 14)
var offset: Vector2 = Vector2(4, 2)
var maxVel: Vector2 = Vector2(100, 200)
var friction: Vector2 = Vector2(600, 0)
var isPlayer: bool = true
var etype: String = 'player'

var type = 'ig.Entity.TYPE.A'
var checkAgainst = 'ig.Entity.TYPE.NONE'

@export var animSheet: AnimatedSprite2D

var flip = false
var accelGround = 400
var accelAir = 200
var jump = 500
@export var jumpSfx: AudioStreamPlayer

var health = 1

var collides :
	get:
		if(self.__collides):
			return self.__collides;

		if (self.vel.y <= 0):
			return 'ig.Entity.COLLIDES.NONE'

		return 'ig.Entity.COLLIDES.PASSIVE'

	set(c):
		self.__collides = c;

var canStandOnCell:
	get:
		return self.collides == 'ig.Entity.COLLIDES.PASSIVE' && !self.standing;

func _init(x, y, settings) -> void:
	pass #super(x, y, settings);


func update():
	var accel = self.accelGround if self.standing else self.accelAir
	if Input.is_action_pressed('left'):
		self.accel.x = -accel;
		self.flip = true;

	elif Input.is_action_pressed('right'):
		self.accel.x = accel;
		self.flip = false;

	else:
		self.accel.x = 0;


	if (self.standing && Input.is_action_pressed('jump')):
		self.vel.y = - self.jump;
		self.jumpSfx.play();


	if (self.vel.y < 0):
		self.currentAnim = self.anims.jump;

	elif (self.vel.y > 0):
		self.currentAnim = self.anims.fall;

	elif (self.vel.x != 0):
		self.currentAnim = self.anims.run;

	else:
		self.currentAnim = self.anims.idle;


	self.currentAnim.flip.x = self.flip;



	if(self.standing):
		self.lastStandingPos = self.pos;

signal player_death

func receiveDamage():
	player_death.emit()
