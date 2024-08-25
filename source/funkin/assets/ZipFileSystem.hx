package funkin.assets;

import funkin.save.Options;
import haxe.zip.Uncompress;
import haxe.io.Bytes;
import sys.io.File;
import lime.media.AudioBuffer;
import lime.media.vorbis.VorbisFile;
import openfl.media.Sound;
import haxe.zip.InflateImpl;
import openfl.utils.ByteArray;
import openfl.display.BitmapData;
import haxe.io.Path;
import sys.io.FileInput;
import haxe.io.Input;
import haxe.zip.Reader;
import haxe.zip.Entry;

class ZipFileSystem extends BaseFileSystem {
	var zip:Zip;

	public function new(path:String) {
		zip = Zip.fromFile(path);
		zip.read();

		this.path = path;
	}

	public function exists(path:String):Bool {
		return getEntry(path) != null;
	}

	public function getBitmapData(path:String):BitmapData {
		return BitmapData.fromBytes(getBytes(path));
	}

	public function getBytes(path:String):ByteArray {
		return zip.unzipEntry(getEntry(path));
	}

	public function getMusic(path:String):Sound {
		if (Options.data.streamMusic) {
			var vorbisFile = VorbisFile.fromBytes(getBytes(path));
			var buffer = AudioBuffer.fromVorbisFile(vorbisFile);
			return Sound.fromAudioBuffer(buffer);
		} else {
			var buffer = AudioBuffer.fromBytes(getBytes(path));
			return Sound.fromAudioBuffer(buffer);
		}
	}

	override function getPath(path:String):String {
		return Path.normalize(path);
	}

	public function getSound(path:String):Sound {
		var buffer = AudioBuffer.fromBytes(getBytes(path));
		return Sound.fromAudioBuffer(buffer);
	}

	public function getText(path:String):String {
		return getBytes(path).toString();
	}

	public function getFont(path:String):String {
		return getTemp(path);
	}

	function getEntry(path:String):ZipEntry {
		var normalizedPath = getPath(path).toLowerCase();
		for (entry in zip.entries) {
			if (Path.normalize(entry.fileName).toLowerCase() == normalizedPath) return entry;
		}
		return null;
	}

	function getTemp(path:String):String {
		var fullPath = '.temp/${Path.withoutDirectory(this.path)}/$path';
		File.saveBytes(fullPath, getBytes(path));
		return fullPath;
	}

	override function toString():String {
		return 'File system ("$path" | Zip)';
	}
}

class Zip extends Reader {
	var input:Input;
	var fileInput:FileInput;

	public var entries:List<ZipEntry>;

	public static function fromFile(path:String) {
		return new Zip(File.read(path, true));
	}

	public function new(input:FileInput) {
		super(input);
		fileInput = input;
	}

	public function readEntryData(e:ZipEntry) {
		var bytes:Bytes = null;
		var buf = null;
		var tmp = null;

		fileInput.seek(e.seekPos, SeekBegin);
		if (e.crc32 == null) {
			if (e.compressed) {
				#if neko
				var bufSize = 65536;
				if (buf == null) {
					buf = new haxe.io.BufferInput(i, Bytes.alloc(bufSize));
					tmp = Bytes.alloc(bufSize);
					i = buf;
				}
				var out = new haxe.io.BytesBuffer();
				var z = new neko.zip.Uncompress(-15);
				z.setFlushMode(neko.zip.Flush.SYNC);
				while (true) {
					if (buf.available == 0) buf.refill();
					var p = bufSize - buf.available;
					if (p != buf.pos) {
						buf.buf.blit(p, buf.buf, buf.pos, buf.available);
						buf.pos = p;
					}
					var r = z.execute(buf.buf, buf.pos, tmp, 0);
					out.addBytes(tmp, 0, r.write);
					buf.pos += r.read;
					buf.available -= r.read;
					if (r.done) break;
				}
				bytes = out.getBytes();
				#else
				var bufSize = 65536;
				if (tmp == null)
					tmp = Bytes.alloc(bufSize);
				var out = new haxe.io.BytesBuffer();
				var z = new InflateImpl(i, false, false);
				while (true) {
					var n = z.readBytes(tmp, 0, bufSize);
					out.addBytes(tmp, 0, n);
					if (n < bufSize) break;
				}
				bytes = out.getBytes();
				#end
			} else bytes = i.read(e.dataSize);

			e.crc32 = i.readInt32();
			if (e.crc32 == 0x08074b50) e.crc32 = i.readInt32();
			e.dataSize = i.readInt32();
			e.fileSize = i.readInt32();
			// set data to uncompressed
			e.dataSize = e.fileSize;
			e.compressed = false;
		} else bytes = i.read(e.dataSize);

		return bytes;
	}

	public function unzipEntry(f:ZipEntry) {
		var data = readEntryData(f);

		if (!f.compressed) return data;
		var c = new Uncompress(-15);
		var s = Bytes.alloc(f.fileSize);
		var r = c.execute(data, 0, s, 0);
		c.close();
		if (!r.done || r.read != data.length || r.write != f.fileSize)
			throw "Invalid compressed data for " + f.fileName;
		data = s;
		return data;
	}

	override function read():List<ZipEntry> {
		if (entries != null) return entries;

		entries = new List();
		while (true) {
			var e = readEntryHeader();
			if (e == null) break;

			var zipEntry = (cast e : ZipEntry);
			zipEntry.seekPos = fileInput.tell();
			entries.add(zipEntry);
			fileInput.seek(e.dataSize, SeekCur);
		}
		return entries;
	}

	public function dispose() {
		input?.close();
	}
}

typedef ZipEntry = Entry & {
	seekPos:Int
}
