package funkin.assets;

import funkin.save.Options;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import lime.media.AudioBuffer;
import lime.media.vorbis.VorbisFile;
import openfl.media.Sound;
import openfl.utils.ByteArray;
import openfl.display.BitmapData;

class FolderFileSystem extends BaseFileSystem {
	public function new(path:String) {
		this.path = path;
	}

	public function exists(path:String):Bool {
		return FileSystem.exists(getPath(path)) && !FileSystem.isDirectory(getPath(path));
	}

	public function getBitmapData(path:String):BitmapData {
		return BitmapData.fromFile(getPath(path));
	}

	public function getBytes(path:String):ByteArray {
		return ByteArray.fromFile(getPath(path));
	}

	public function getMusic(path:String):Sound {
		if (Options.data.streamMusic) {
			var vorbisFile = VorbisFile.fromFile(getPath(path));
			var buffer = AudioBuffer.fromVorbisFile(vorbisFile);
			return Sound.fromAudioBuffer(buffer);
		} else
			return Sound.fromFile(getPath(path));
	}

	override function getPath(path:String):String {
		return Path.join([this.path, path]);
	}

	public function getSound(path:String):Sound {
		return Sound.fromFile(getPath(path));
	}

	public function getText(path:String):String {
		return File.getContent(getPath(path));
	}

	public function getFont(path:String):String {
		return getPath(path);
	}

	override function toString():String {
		return 'File system ("$path" | Folder)';
	}
}
