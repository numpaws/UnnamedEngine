package funkin.runtime.scripts;

import funkin.assets.Paths;
import haxe.io.Path;

class Script {
	static var knownExtensions = [
		'hx', 'hxp', 'hscript', 'haxe', 'hxs', 'hxc',
		'lua'
	];

	public static function fromFile(path:String):Script {
		if (!Paths.exists(path)) {
			trace('$path does not exists');
			return new Script();
		}

		switch(Path.extension(path).toLowerCase()) {
			case 'hx' | 'hxp' | 'hscript' | 'haxe' | 'hxs' | 'hxc':
				return new HScript(path);

			case 'lua':
				return new LuaScript(path);

			case unknown:
				trace('.$unknown is not supported script extension');
				return new Script();
		}
	}

	public static var global:Script;
	public static function runGlobalScript() {
		for (extension in knownExtensions) {
			var path = 'data/global.$extension';
			if (Paths.exists(path)) {
				global = fromFile(path);
				break;
			}
		}
		global?.run();
	}

	function new() {}

	public function setParent(parent:Dynamic) {}

	public function run():Any {
		return null;
	}

	public function set(name:String, value:Any) {}
	public function get(name:String):Null<Any> {
		return null;
	}

	public function call(name:String, args:Array<Dynamic>):Any {
		return null;
	}
}
