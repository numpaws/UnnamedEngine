package funkin.save;

import flixel.FlxG;

enum abstract NoteClipMethod(String) from String to String {
	var None = 'none';
	var Legacy = 'legacy';
	var Modern = 'modern';
}

@:structInit @:publicFields
class OptionsData {
	var modOptions:Map<String, Map<String, Dynamic>> = [];

	var streamMusic = true;
	var multiThreading = true;
	var fastMath = false;

	var noteClipMethod:NoteClipMethod = Modern;
	var downscroll = false;

	var antialiasing = true;
	var lowMemory = false;
	var flashing = true;
}

class Options {
	public static var data(default, null):OptionsData = {};

	public static function load() {
		var save = FlxG.save.data?.options;

		if (save == null) {
			// trace('No saved options were found, maybe save is not loaded');
			return;
		}

		data = {};
		for (option in Reflect.fields(save)) {
			if (Reflect.hasField(data, option))
				Reflect.setField(data, option, Reflect.field(save, option));
		}
	}

	public static function save() {
		FlxG.save.data.options = ({} : Dynamic);
		for (option in Reflect.fields(data)) {
			Reflect.setField(FlxG.save.data.options, option, Reflect.field(data, option));
		}

		try {
			FlxG.save.flush();
		} catch(exception) trace('Error occurred while saving options: $exception');
	}
}
