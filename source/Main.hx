import flixel.util.typeLimit.NextState;
import funkin.util.CliUtil;
import funkin.save.HighScore;
import flixel.math.FlxPoint;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxRect;
import flixel.addons.transition.TransitionData.TransitionTileData;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.graphics.FlxGraphic;
import funkin.runtime.scripts.Script;
import funkin.save.Options;
import flixel.FlxG;
import lime.graphics.Image;
import funkin.runtime.Mod;
import sys.io.File;
import sys.FileSystem;
import funkin.assets.Paths;
import funkin.display.performance.PerformanceDisplay;
import flixel.FlxGame;
import openfl.display.Sprite;

using StringTools;

class Main extends Sprite {
	public static var initialState:NextState = () -> new funkin.runtime.xml.XmlState('mainmenu');
	public function new() {
		CliUtil.process();

		super();

		// Add assets sources
		Paths.addFileSystem('assets');
		if (FileSystem.exists('currentMod.txt')) {
			var currentMod = File.getContent('currentMod.txt');
			if (currentMod.trim().length > 0) Mod.initialize(currentMod);
		}

		// Load saved options
		FlxG.save.bind('UnnamedEngine/engine', 'numpaws');
		Options.load();
		HighScore.load();

		PerformanceDisplay.instance = new PerformanceDisplay(10, 3);

		addChild(new FlxGame(1280, 720, null, 60, 60, true, false));

		setupTransitions();

		Script.runGlobalScript();

		FlxG.switchState(initialState);

		addChild(PerformanceDisplay.instance);

		// Change window icon
		var windowIcon = Image.fromBytes(Paths.getBytes('images/internal/iconOG.png'));
		FlxG.stage.window.setIcon(windowIcon);
	}

	function setupTransitions() {
		var diamond = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.destroyOnNoUse = false;
		diamond.persist = true;
		var tileData:TransitionTileData = {asset: diamond, width: 32, height: 32};
		var region = FlxRect.get(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4);
		FlxTransitionableState.defaultTransIn = new TransitionData(TransitionType.FADE, 0xFF000000, 1, FlxPoint.get(0, -1), tileData, region);
		FlxTransitionableState.defaultTransOut = new TransitionData(TransitionType.FADE, 0xFF000000, 0.7, FlxPoint.get(0, 1), tileData, region);
		FlxTransitionableState.skipNextTransIn = true;
	}
}
