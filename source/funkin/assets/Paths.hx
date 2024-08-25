package funkin.assets;

import openfl.media.Sound;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import openfl.utils.ByteArray;
import haxe.io.Path;
import sys.FileSystem;

using StringTools;

class Paths {
	static var fileSystems:Array<BaseFileSystem> = [];

	public static function addFileSystem(path:String, highPriority = false):BaseFileSystem {
		var normalizedPath = Path.normalize(path);
		for (fs in fileSystems) {
			if (fs.path == normalizedPath || fs.path == '$normalizedPath.zip') {
				trace('$fs already exists');
				return null;
			}
		}

		var fs:BaseFileSystem = null;

		if (FileSystem.exists(path) && FileSystem.isDirectory(path)) fs = new FolderFileSystem(path);
		else if (path.endsWith('.zip') && FileSystem.exists(path)) fs = new ZipFileSystem(path);
		else if (FileSystem.exists('$path.zip')) fs = new ZipFileSystem('$path.zip');

		if (fs == null) {
			trace('Invalid path');
			return null;
		}

		if (highPriority) fileSystems.insert(0, fs);
		else fileSystems.push(fs);
		trace('$fs was added');

		return fs;
	}

	public static function getFileSystem(path:String):BaseFileSystem {
		var normalizedPath = Path.normalize(path);
		for (fs in fileSystems) {
			if (fs.path == normalizedPath) return fs;
		}

		trace('$path does not exist in file systems');
		return null;
	}

	public static inline function hasFileSystem(path:String):Bool {
		return getFileSystem(path) != null;
	}

	public static function removeFileSystem(path:String) {
		var fs = getFileSystem(path);
		if (fs == null) return;

		fileSystems.remove(fs);
		trace('$fs was removed');
	}

	public static function clearCache() {
		FlxG.bitmap.clearCache();
	}

	public static function getBytes(path:String, warn = true):ByteArray {
		for (fs in fileSystems) {
			if (fs.exists(path)) return fs.getBytes(path);
		}

		if (warn) trace('Binary $path does not exist');
		return null;
	}

	public static function image(path:String, warn = true):FlxGraphic {
		var fullPath = 'images/$path.png';

		var graphic = FlxG.bitmap.get(fullPath);
		if (graphic != null) return graphic;

		for (fs in fileSystems) {
			if (fs.exists(fullPath)) {
				var bitmapData = fs.getBitmapData(fullPath);
				graphic = FlxG.bitmap.add(bitmapData, path);
				graphic.destroyOnNoUse = false;
				graphic.persist = true;
				return graphic;
			}
		}

		if (warn) trace('Image ${path} does not exist');
		return null;
	}

	public static function getText(path:String, warn = true):String {
		for (fs in fileSystems) {
			if (fs.exists(path)) return fs.getText(path);
		}

		if (warn) trace('Text $path does not exist');
		return null;
	}

	public static function exists(path:String):Bool {
		for (fs in fileSystems) {
			if (fs.exists(path)) return true;
		}

		return false;
	}

	public static function music(path:String, warn = true):Sound {
		var fullPath = 'music/$path.ogg';
		for (fs in fileSystems) {
			if (fs.exists(fullPath)) return fs.getMusic(fullPath);
		}

		if (warn) trace('Music $path does not exist');
		return null;
	}

	public static function font(path:String, warn = true):String {
		var fullPath = 'fonts/$path.ttf';
		for (fs in fileSystems) {
			if (fs.exists(fullPath)) return fs.getFont(fullPath);
		}

		fullPath = 'fonts/$path.otf';
		for (fs in fileSystems) {
			if (fs.exists(fullPath)) return fs.getFont(fullPath);
		}

		if (warn) trace('Font $path does not exist');
		return null;
	}

	public static function sound(path:String, warn = true):Sound {
		var fullPath = 'sounds/$path.ogg';
		for (fs in fileSystems) {
			if (fs.exists(fullPath)) return fs.getSound(fullPath);
		}

		if (warn) trace('Sound $path does not exist');
		return null;
	}
}
