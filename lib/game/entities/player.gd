class_name Player
extends CharacterBody2D

var size: Vector2i = Vector2i(8, 14)
var offset: Vector2i = Vector2i(4, 2)
var maxVel: Vector2i = Vector2i(100, 200)
var friction: Vector2i = Vector2i(600, 0)
var isPlayer: bool = true
var etype: String = 'player'

var vel: Vector2i = Vector2i.ZERO

var is_standing: bool = true

var type = 'ig.Entity.TYPE.A'
var checkAgainst = 'ig.Entity.TYPE.NONE'

@export var sprite: AnimatedSprite2D

var flip: bool = false

@export_group('Acceleration', 'accel')
@export var accel_ground: int = 400
@export var accel_air: int = 200
var accel: Vector2i = Vector2i.ZERO


@export var jump: int = 500
@export var jump_sound: AudioStreamPlayer

var last_position: Vector2i = Vector2i.ZERO

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
	accel.x = accel_ground if is_standing else accel_air

	var input: int = int(Input.get_axis(&'left', &'right'))
	var direction: int = signi(input)
	if input != 0:
		flip = direction == -1

	accel.x *= direction


	if is_standing && Input.is_action_pressed(&'jump'):
		vel.y = -jump
		jump_sound.play()


	if vel.y < 0:
		sprite.play(&'jump')

	elif (self.vel.y > 0):
		sprite.play(&'fall')

	elif (self.vel.x != 0):
		sprite.play(&'run')

	else:
		sprite.play(&'idle')


	scale.x *= direction

	if is_standing:
		last_position = position

signal player_death

func receiveDamage():
	player_death.emit()
