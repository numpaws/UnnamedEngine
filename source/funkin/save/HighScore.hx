package funkin.save;

import flixel.util.FlxStringUtil;
import flixel.FlxG;

class HighScore {
	static var songTallies:Map<String, Map<String, Tallies>> = [];
	static var weekTallies:Map<String, Map<String, Tallies>> = [];

	public static function load() {
		songTallies = FlxG.save.data?.songTallies ?? new Map<String, Map<String, Tallies>>();
		weekTallies = FlxG.save.data?.weekTallies ?? new Map<String, Map<String, Tallies>>();
	}

	public static function save() {
		FlxG.save.data.songTallies = songTallies;
		FlxG.save.data.weekTallies = weekTallies;

		try {
			FlxG.save.flush();
		} catch(exception) trace('Error occurred while saving high scores: $exception');
	}

	public static function getSongTallies(song:String, difficulty:String):Tallies {
		return songTallies.get(song)?.get(difficulty) ?? new Tallies();
	}

	public static function setSongTallies(song:String, difficulty:String, tallies:Tallies) {
		if (tallies < getSongTallies(song, difficulty)) return;

		if (!songTallies.exists(song)) songTallies[song] = new Map<String, Tallies>();
		songTallies[song][difficulty] = tallies;

		save();
	}

	public static function getWeekTallies(week:String, difficulty:String):Tallies {
		return weekTallies.get(week)?.get(difficulty) ?? new Tallies();
	}

	public static function saveWeekTallies(week:String, difficulty:String, tallies:Tallies) {
		if (tallies < getSongTallies(week, difficulty)) return;

		if (!weekTallies.exists(week)) weekTallies[week] = new Map<String, Tallies>();
		weekTallies[week][difficulty] = tallies;

		save();
	}
}

@:forward
abstract Tallies(RawTallies) from RawTallies to RawTallies {
	public function new() {
		this = {
			score: 0,

			sicks: 0,
			goods: 0,
			bads: 0,
			shits: 0,
			misses: 0,

			accuracy: -1
		}
	}

	@:op(a > b)
	static function greaterThan(a:Tallies, b:Tallies):Bool {
		return a.score > b.score;
	}

	@:op(a < b)
	static function lessThan(a:Tallies, b:Tallies):Bool {
		return a.score < b.score;
	}

	@:op(a + b)
	static function add(a:Tallies, b:Tallies):Tallies {
		return {
			score: a.score + b.score,

			sicks: a.sicks + b.sicks,
			goods: a.goods + b.goods,
			bads: a.bads + b.bads,
			shits: a.shits + b.shits,
			misses: a.misses + b.misses,

			accuracy: (a.accuracy + b.accuracy) / 2
		}
	}
}

typedef RawTallies = {
	score:Int,

	sicks:Int,
	goods:Int,
	bads:Int,
	shits:Int,
	misses:Int,

	accuracy:Float
}
