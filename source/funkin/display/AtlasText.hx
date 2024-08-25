package funkin.display;

import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import funkin.assets.Paths;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxSprite;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;

using StringTools;

class AtlasText extends FlxTypedSpriteContainer<AtlasCharacter> {
	static var fonts:Map<String, AtlasFont> = [];
	var _font:AtlasFont;

	public var text(default, set) = '';

	public var font(default, set) = 'default';

	public function new(x = 0.0, y = 0.0, ?text:String, ?font:String) {
		if (font == null) font = this.font;

		if (!fonts.exists(font)) fonts[font] = new AtlasFont(font);
		_font = fonts[font];

		super(x, y);

		this.text = text;
	}

	function set_text(v) {
		if (v == null) v = '';

		var cased = restrictCase(v);
		var oldCased = restrictCase(text);

		if (oldCased == cased) return v;

		if (cased.startsWith(oldCased)) {
			appendTextCased(cased.substr(oldCased.length));
			return text = v;
		}

		group.kill();

		if (v == '') return v;

		appendTextCased(cased);
		return text = v;
	}

	function set_font(v) {
		if (font == v) return v;

		if (!fonts.exists(v)) fonts[v] = new AtlasFont(v);
		_font = fonts[v];

		var text = this.text;
		this.text = '';
		this.text = text;

		return font = v;
	}

	public function appendText(text:String) {
		if (text == null) {
			trace('Cannot append NULL');
			return;
		}

		if (text.trim().length == 0) return;

		this.text += text;
	}

	function restrictCase(text:String):String {
		return switch(_font.caseAllowed) {
			case Upper: text.toUpperCase();
			case Lower: text.toLowerCase();
			default: text;
		}
	}

	function appendTextCased(text:String) {
		var characterAmount = FlxMath.maxInt(group.countLiving(), 0);

		var position = FlxPoint.get();

		if (characterAmount > 0) {
			var lastCharacter = group.members[characterAmount - 1];
			position.x = lastCharacter.x + lastCharacter.width - x;
			position.y = lastCharacter.y - y;
		}

		for (character in text.split('')) {
			switch (character) {
				case ' ':
					position.x += 40;

				case '\n':
					position.x = 0;
					position.y += _font.maxHeight;

				default:
					var sprite:AtlasCharacter;
					if (group.length <= characterAmount) {
						sprite = new AtlasCharacter(_font.frames, character);
						add(sprite);
					} else {
						sprite = group.members[characterAmount];
						sprite.revive();
						sprite.character = character;
						sprite.alpha = 1;
					}

					sprite.x = position.x + x;
					sprite.y = position.y + _font.maxHeight - sprite.height + y;
					sprite.antialiasing = antialiasing;

					position.x += sprite.width;
					characterAmount++;
			}
		}
	}

	override function toString():String {
		return 'Atlas text ($font | $text)';
	}

	override function set_antialiasing(v) {
		for (character in members) character.antialiasing = v;
		return antialiasing = v;
	}
}

class AtlasCharacter extends FlxSprite {
	public var character(default, set):String;

	public function new(x = 0.0, y = 0.0, frames:FlxAtlasFrames, character:String) {
		super(x, y);
		this.frames = frames;
		this.character = character;
	}

	function set_character(v) {
		if (character == v) return v;

		var prefix = getAnimationPrefix(v);
		animation.addByPrefix(v, prefix, 24);
		if (animation.exists(v)) animation.play(v);
		else trace('Animation for char "$v" does not exist');
		updateHitbox();

		return character = v;
	}

	static function getAnimationPrefix(character:String):String {
		return switch(character) {
			case '&': '-andpersand-';
			case '😠': '-angry-faic-';
			case '\'': '-apostraphie-';
			case '\\': '-back slash-';
			case ',': '-comma-';
			case '-': '-dash-';
			case '↓': '-down arrow-';
			case '”': '-end quote-';
			case '!': '-exclamation point-';
			case '/': '-forward slash-';
			case '>': '-greater than-';
			case '♥' | '♡': '-heart-';
			case '←': '-left arrow-';
			case '<': '-less than-';
			case '*': '-multiply x-';
			case '.': '-period-';
			case '?': '-question mark-';
			case '→': '-right arrow-';
			case '“': '-start quote-';
			case '↑': '-up arrow-';

			default: character;
		}
	}
}

class AtlasFont {
	public static final UPPER_CHAR = ~/^[A-Z]\d+$/;
	public static final LOWER_CHAR = ~/^[a-z]\d+$/;

	public final frames:FlxAtlasFrames;
	public final maxHeight = 0.0;
	public final caseAllowed:Case = Both;

	public function new(name:String) {
		frames = FlxAtlasFrames.fromSparrow(Paths.image('fonts/$name'), Paths.getText('images/fonts/$name.xml'));

		var hasUpper = false;
		var hasLower = false;

		for (frame in frames.frames) {
			maxHeight = Math.max(maxHeight, frame.frame.height);

			if (!hasUpper) hasUpper = UPPER_CHAR.match(frame.name);
			if (!hasLower) hasLower = LOWER_CHAR.match(frame.name);
		}

		if (hasUpper != hasLower) caseAllowed = hasUpper ? Upper : Lower;
	}
}

enum Case {
	Both;
	Upper;
	Lower;
}
