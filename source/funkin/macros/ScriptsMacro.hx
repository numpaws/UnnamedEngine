package funkin.macros;

import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Expr.Field;

class ScriptsMacro {
	public static macro function run():Array<Field> {
		Compiler.include('funkin', ['funkin.macros']);
		Compiler.include('flixel.system', ['flixel.system.macros']);

		for (pack in [
			// BASE HAXE
			'DateTools',		'EReg',			'Lambda',
			'StringBuf',		'haxe.crypto',	'haxe.display',
			'haxe.exceptions',	'haxe.extern',
			// FLIXEL
			'flixel.ui',		'flixel.tweens',	'flixel.tile',		'flixel.text',		'flixel.sound',		'flixel.path',		'flixel.math',		'flixel.input',		'flixel.group',		'flixel.graphics',	'flixel.effects',	'flixel.animation',
			// FLIXEL ADDONS
			'flixel.addons.api',	'flixel.addons.display',	'flixel.addons.effects',	'flixel.addons.ui',
			'flixel.addons.plugin',	'flixel.addons.text',		'flixel.addons.tile',		'flixel.addons.transition',
			'flixel.addons.util',
			// OTHER LIBRARIES & STUFF
			'sys', 'openfl.net',
			#if hxvlc 'hxvlc.flixel', 'hxvlc.openfl', #end
		]) Compiler.include(pack);

		return Context.getBuildFields();
	}
}
