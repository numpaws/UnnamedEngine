package funkin.util;

import funkin.save.Options;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxMath;

class MathUtil {
	public static function sin(n:Float):Float {
		return Options.data.fastMath ? FlxMath.fastSin(n) : Math.sin(n);
	}

	public static function cos(n:Float):Float {
		return Options.data.fastMath ? FlxMath.fastCos(n) : Math.cos(n);
	}

	public static function lerp(a:Float, b:Float, ratio:Float, fpsSensitive = false):Float {
		if (fpsSensitive) ratio = fpsRatio(ratio);
		return FlxMath.lerp(a, b, ratio);
	}

	public static function lerpColor(a:FlxColor, b:FlxColor, ratio:Float, fpsSensitive = false):Float {
		if (fpsSensitive) ratio = fpsRatio(ratio);
		return FlxColor.interpolate(a, b, ratio);
	}

	public static function fpsRatio(ratio:Float):Float {
		return FlxMath.bound(ratio * 60 * FlxG.elapsed, 0, 1);
	}
}
