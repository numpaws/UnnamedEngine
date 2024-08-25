package funkin.display.performance;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Sprite;

class PerformanceDisplay extends Sprite {
	public static inline var FONT = 'Nirmala UI';

	public static var instance:PerformanceDisplay;

	var fpsDisplay:FPSDisplay;
	var memoryDisplay:MemoryDisplay;
	var infoDisplay:InfoDisplay;

	var background:Bitmap;

	public function new(x = 0.0, y = 0.0) {
		if (instance != null) {
			trace('Cannot create second performance display');
			return;
		}

		super();

		this.x = x;
		this.y = y;

		fpsDisplay = new FPSDisplay();
		addChildListed(fpsDisplay);

		memoryDisplay = new MemoryDisplay();
		addChildListed(memoryDisplay);

		infoDisplay = new InfoDisplay();
		// addChildListed(infoDisplay);

		background = new Bitmap(new BitmapData(1, 1, false, 0xFF000000));
		background.x = -x;
		background.y = -y;
		background.alpha = 0.6;
		addChildAt(background, 0);
	}

	public function addChildListed(child:DisplayObject) {
		child = super.addChild(child);
		if (child == null) {
			trace('Child is NULL');
			return;
		}

		var lastChild = getChildAt(numChildren - 2);
		if (lastChild != null) child.y = lastChild.y + lastChild.height;
	}

	override function __enterFrame(deltaTime:Int) {
		background.x = -x;
		background.y = -y;
		var lastChild = getChildAt(numChildren - 1);
		if (lastChild != null) {
			background.scaleX = lastChild.x + lastChild.width + x * 2;
			background.scaleY = lastChild.y + lastChild.height + y * 2;
		}

		if (alpha > 0.05 && visible) super.__enterFrame(deltaTime);
	}
}
