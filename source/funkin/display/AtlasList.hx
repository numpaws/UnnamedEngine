package funkin.display;

import funkin.save.Options;
import funkin.util.MathUtil;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;

class AtlasList extends FlxTypedSpriteContainer<AtlasText> {
	public var distanceBetweenItems = FlxPoint.get(20, 140);

	public var selectable(default, set) = false;
	public var selection = 0;
	public var unselectedAlpha = 0.6;

	public function new(labels:Array<String>, ?font:String) {
		super();

		for (i => label in labels) {
			var text = new AtlasText(i * distanceBetweenItems.x, i * 1.3 * distanceBetweenItems.y, label, font);
			text.antialiasing = Options.data.antialiasing;
			add(text);
		}

		if (selectable) changeSelection();
	}

	function set_selectable(v) {
		if (v) changeSelection();
		else for (item in members) item.alpha = 1;

		return selectable = v;
	}

	override function update(elapsed:Float) {
		for (i => item in members) {
			item.x = x + i * distanceBetweenItems.x;
			item.y = y + i * distanceBetweenItems.y;
		}

		if (selectable) {
			var deltaSelection = 0;
			if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP) deltaSelection--;
			if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.DOWN) deltaSelection++;
			if (FlxG.mouse.wheel != 0) deltaSelection -= FlxMath.signOf(FlxG.mouse.wheel);

			if (deltaSelection != 0) changeSelection(deltaSelection);

			offset.x = MathUtil.lerp(offset.x, members[selection].x - x, 0.16, true);
			offset.y = MathUtil.lerp(offset.y, members[selection].y - y, 0.16, true);
		}

		super.update(elapsed);
	}

	function changeSelection(delta = 0) {
		selection = FlxMath.wrap(selection + delta, 0, length - 1);

		for (i => item in members) {
			if (i == selection) item.alpha = 1;
			else item.alpha = unselectedAlpha;
		}
	}
}
