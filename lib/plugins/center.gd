
class MixinCenter:
	var center

	func draw() -> void:
		self.parent();
		if (ig.drawDebugInfo):
			self._drawCenter();
			self._drawBoundingBox();



	func update():
		self.parent();
		self.center.x = self.pos.x + self.size.x / 2;
		self.center.y = self.pos.y + self.size.y / 2;


	func _drawCenter():
		var c = ig.system.context;
		var s = ig.system.scale;
		c.fillStyle = 'magenta';
		var size = 2;
		c.fillRect((this.center.x - (size / 2) - ig.game.screen.x) * s, (this.center.y - (size / 2) - ig.game.screen.y) * s, size * s, size * s);


	func _drawBoundingBox():
		var c = ig.system.context;
		var s = ig.system.scale;
		c.strokeStyle = this.boundingBoxColor || 'rgb(100, 255, 20)';
		c.strokeRect((this.pos.x - ig.game.screen.x) * s, (this.pos.y - ig.game.screen.y) * s, this.size.x * s, this.size.y * s);
