package funkin.display.performance;

import funkin.util.MemoryUtil;
import flixel.util.FlxStringUtil;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.display.Sprite;

class MemoryDisplay extends Sprite {
	var usedDisplay:TextField;
	var percentDisplay:TextField;

	public function new() {
		super();

		usedDisplay = new TextField();

		percentDisplay = new TextField();
		percentDisplay.alpha = 0.6;

		for (tf in [usedDisplay, percentDisplay]) {
			tf.autoSize = LEFT;
			tf.wordWrap = false;
			tf.selectable = false;
			tf.defaultTextFormat = new TextFormat(PerformanceDisplay.FONT, tf == usedDisplay ? 14 : 13, 0xFFFFFFFF);
			addChild(tf);
		}
	}

	override function __enterFrame(deltaTime:Int) {
		usedDisplay.text = FlxStringUtil.formatBytes(MemoryUtil.getUsedBytes());

		percentDisplay.text = ' (${Math.floor(MemoryUtil.getUsedBytes() / MemoryUtil.getAllocatedBytes() * 100)}%)';
		percentDisplay.x = usedDisplay.x + usedDisplay.width;
		percentDisplay.y = usedDisplay.y + (usedDisplay.height - percentDisplay.height);

		if (alpha > 0.05 && visible) super.__enterFrame(deltaTime);
	}
}
