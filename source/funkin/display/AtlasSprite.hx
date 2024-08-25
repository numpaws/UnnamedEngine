package funkin.display;

import flixel.graphics.frames.FlxAtlasFrames;
import funkin.assets.Paths;
import flixel.FlxSprite;

class AtlasSprite extends FlxSprite {
	public function new(x = 0.0, y = 0.0, ?image:String) {
		super(x, y);
		if (image != null) load(image);
	}

	public function load(image:String, tiles = false, tileWidth = 0, tileHeight = 0):AtlasSprite {
		var graphic = Paths.image(image);

		if (tiles) {
			loadGraphic(graphic, true, tileWidth, tileHeight);
			return this;
		}

		var sparrow = Paths.getText('images/$image.xml', false);
		if (graphic != null && sparrow != null) {
			frames = FlxAtlasFrames.fromSparrow(graphic, sparrow);
			return this;
		}

		var sheet = Paths.getText('images/$image.txt', false);
		if (graphic != null && sheet != null) {
			frames = FlxAtlasFrames.fromSpriteSheetPacker(graphic, sheet);
			return this;
		}

		var aseprite = Paths.getText('images/$image.json', false);
		if (graphic != null && aseprite != null) {
			frames = FlxAtlasFrames.fromAseprite(graphic, aseprite);
			return this;
		}

		if (graphic != null) loadGraphic(graphic);

		return this;
	}
}
