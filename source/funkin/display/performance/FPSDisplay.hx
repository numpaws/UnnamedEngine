package funkin.display.performance;

import flixel.FlxG;
import funkin.util.MathUtil;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.display.Sprite;

class FPSDisplay extends Sprite {
	public var currentFPS = 0.0;

	var fpsNumber:TextField;
	var fpsLabel:TextField;

	public function new() {
		super();

		fpsNumber = new TextField();

		fpsLabel = new TextField();
		fpsLabel.text = 'FPS';

		for (tf in [fpsNumber, fpsLabel]) {
			tf.autoSize = LEFT;
			tf.wordWrap = false;
			tf.selectable = false;
			tf.defaultTextFormat = new TextFormat(PerformanceDisplay.FONT, tf == fpsNumber ? 16 : 13, 0xFFFFFFFF);
			addChild(tf);
		}
	}

	override function __enterFrame(deltaTime:Int) {
		currentFPS = MathUtil.lerp(currentFPS, FlxG.elapsed <= 0 ? 0 : (1 / FlxG.elapsed), 0.25, true);

		fpsNumber.text = Std.string(Math.floor(currentFPS));

		fpsLabel.x = fpsNumber.x + fpsNumber.width;
		fpsLabel.y = fpsNumber.y + (fpsNumber.height - fpsLabel.height);

		if (alpha > 0.05 && visible) super.__enterFrame(deltaTime);
	}
}
