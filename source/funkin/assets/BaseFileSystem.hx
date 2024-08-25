package funkin.assets;

import haxe.io.Path;
import openfl.media.Sound;
import openfl.utils.ByteArray;
import openfl.display.BitmapData;

abstract class BaseFileSystem {
	public var path(default, set):String;

	function set_path(v) {
		return path = Path.normalize(v);
	}

	public abstract function exists(path:String):Bool;
	public abstract function getBitmapData(path:String):BitmapData;
	public abstract function getBytes(path:String):ByteArray;
	public abstract function getMusic(path:String):Sound;

	public function getPath(path:String) {
		return path;
	}

	public abstract function getSound(path:String):Sound;
	public abstract function getText(path:String):String;

	public abstract function getFont(path:String):String;

	public function toString():String {
		return 'File system (no backend)';
	}
}
