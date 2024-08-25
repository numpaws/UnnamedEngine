package funkin.data;

import haxe.Json;
import funkin.assets.Paths;

@:forward
abstract SongData(RawSongData) from RawSongData to RawSongData {
	public function new(name:String, artist:String, bpm:Float, icon:String, color:String, scrollSpeed:Float) {
		this = {
			meta: {
				name: name,
				artist: artist,
				bpm: bpm,
				icon: icon
				color: color
			},
			chart: {
				strumLines: [
					{
						character: 'bf-pixel',
						scrollSpeed: 1
					},
					{
						character: 'bf',
						scrollSpeed: 1
					}
				],
				scrollSpeed: 1
			},
			events: []
		}
	}

	public static function get(name:String, difficulty:String):SongData {
		if (!Paths.exists('songs/$name/meta.json')) {
			trace('Song "$name" has no meta');
			return new SongData('Unknown', 'Unknown', 100, 'face', '#000000', 1);
		}
		if (!Paths.exists('songs/$name/charts/$difficulty.json')) {
			trace('Song "$name" has no chart');
			return new SongData('Unknown', 'Unknown', 100, 'face', '#000000', 1);
		}

		var result:SongData = {
			meta: Json.parse(Paths.getText('songs/$name/meta.json')),
			chart: Json.parse(Paths.getText('songs/$name/charts/$difficulty.json')),
			events: []
		}
		if (Paths.exists('songs/$name/events.json')) result.events = Json.parse(Paths.getText('songs/$name/events.json'));

		return result;
	}
}

typedef RawSongData = {
	meta:SongMeta,
	chart:SongChart,
	events:Array<SongEvent>
}

typedef SongMeta = {
	name:String,
	artist:String,
	bpm:Float,
	icon:String,
	color:String
}

typedef SongChart = {
	strumLines:Array<SongStrumLine>,
	scrollSpeed:Float
}

typedef SongStrumLine = {
	character:String,
	notes:Array<SongNote>,
	scrollSpeed:Float
}

typedef SongNote = {
	id:Int,
	time:Float,
	length:Float,
	type:String
}

typedef SongEvent = {
	name:String,
	params:Array<Dynamic>
}
