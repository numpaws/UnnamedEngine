package funkin.play;

import funkin.runtime.scripts.ScriptManager;
import funkin.data.SongData;
import flixel.addons.transition.FlxTransitionableState;

class PlayState extends FlxTransitionableState {
	public static var SONG:SongData;
	public static var instance:PlayState;

	var scripts = new ScriptManager();

	public function new() {
		if (instance != null) throw 'You cannot create second instance of ${Type.getClassName(Type.getClass(this))}';
		else instance = this;

		super();
	}

	override function create() {
		super.create();
	}

	override function destroy() {
		instance = null;

		super.destroy();
	}
}
