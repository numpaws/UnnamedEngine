package funkin.util;

import flixel.util.FlxColor;

using StringTools;

class StringUtil {
	public static function parseColor(s:String):FlxColor {
		var hideChars = ~/[\t\n\r]/;
		var color = hideChars.split(s).join('').trim();

		var result = FlxColor.fromString(color);
		if (result == null) result = FlxColor.fromString('#$color');
		return result ?? 0xFFFFFFFF;
	}

	public static function formatFileName(s:String):String {
		#if linux
		var illegalCharacters = ['/'];
		#elseif windows
		var illegalCharacters = ['<', '>', ':', '"', '/', '\\', '|', '?', '*'];
		#else
		var illegalCharacters = [];
		#end

		#if windows
		var illegalNames = ['con', 'prn', 'aux', 'nul'];
		for (i in 1...10) {
			illegalNames.push('com$i');
			illegalCharacters.push('lpt$i');
		}
		#else
		var illegalNames = [];
		#end

		var result = s;
		for (illegalCharacter in illegalCharacters) result = result.replace(illegalCharacter, '');

		if (illegalNames.contains(result.toLowerCase())) throw 'Illegal file name';
		return result;
	}
}
