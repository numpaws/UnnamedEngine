package funkin.play;

import flixel.math.FlxMath;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxRect;
import funkin.save.Options;
import funkin.display.AtlasSprite;

class Note extends AtlasSprite {
	// modern clip stuff
	var _vertices = new DrawData<Float>();
	var _indices = new DrawData<Int>();
	var _uvtData = new DrawData<Float>();

	/** Parent strum **/
	public var strum:AtlasSprite;

	// public var

	public var xOffset = 0.0;
	public var yOffset = 0.0;

	// sustain stuff
	public final isSustain = false;
	public var holding = false;

	// custom stuff
	public var canIgnore = false;

	// input stuff
	public var handledHit = false;
	public var handledMiss = false;

	public function updateClipping() {
		var center = strum.y + StrumLine.STRUM_WIDTH / 2;
		var clipHeight = Options.data.downscroll ? strum.y - y : y - strum.y;
		clipHeight = FlxMath.bound(clipHeight, 0, graphic.height);

		var bottomHeight = graphic.height;
		var partHeight = clipHeight - bottomHeight;

		// #region HOLD VERTICES

		// top left
		_vertices[0 * 2] = 0;
		_vertices[0 * 2 + 1] = flipY ? clipHeight : graphic.height - clipHeight;

		// top right
		_vertices[1 * 2] = graphic.width;
		_vertices[1 * 2 + 1] = _vertices[0 * 2 + 1];

		// bottom left
		_vertices[2 * 2] = 0;
		_vertices[2 * 2 + 1] = partHeight > 0 ? (flipY ? bottomHeight : _vertices[1] + partHeight) : _vertices[0 * 2 + 1];

		// bottom right
		_vertices[3 * 2] = graphic.width;
		_vertices[3 * 2 + 1] = _vertices[2 * 2 + 1];

		// #region HOLD UVs

		_uvtData[0 * 2] = 1 / 4 * (nodeDat)
	}
}
