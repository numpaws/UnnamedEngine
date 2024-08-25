package funkin.display.performance;

import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.display.Sprite;

class InfoDisplay extends Sprite {
	var versionLabel:TextField;

	public function new() {
		super();

		versionLabel = new TextField();
		versionLabel.text = '\nUnnamed Engine\nSHOWCASE BUILD';
		versionLabel.autoSize = LEFT;
		versionLabel.wordWrap = false;
		versionLabel.selectable = false;
		versionLabel.defaultTextFormat = new TextFormat(PerformanceDisplay.FONT, 11, 0xFFFFFFFF);
		addChild(versionLabel);
	}
}
