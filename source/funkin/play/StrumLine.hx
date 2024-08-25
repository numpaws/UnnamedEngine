package funkin.play;

import funkin.display.AtlasSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

enum abstract StrumLineType(String) from String to String {
	var Opponent;
	var Player;
	var Additional;
}

class StrumLine extends FlxSpriteGroup {
	public static final STRUM_WIDTH = 160 * 0.7;

	public var type:StrumLineType;
	public var pixel = false;

	public var strums:Array<AtlasSprite> = [];
	public var notes:Array<Note> = [];

	public function new(type:StrumLineType, xPercent:Float, yPosition:Float) {
		super(FlxG.width * xPercent, yPosition);
		this.type = type;

		for (i in 0...4) {
			var strum = new AtlasSprite(STRUM_WIDTH * i, 0, 'NOTE_assets');
			stru
		}
	}

	public function reloadNotes() {

	}
}
