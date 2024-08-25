package funkin.runtime.scripts;

import flixel.FlxG;
import funkin.assets.Paths;
import hscript.Expr;
import hscript.Parser;
import hscript.Interp;

class HScript extends Script {
	var parser = new Parser();
	var interp = new Interp();
	var expr:Expr;

	@:allow(funkin.runtime.scripts.Script)
	function new(path:String) {
		super();

		parser.allowJSON = true;
		parser.allowMetadata = true;
		parser.allowTypes = true;
		parser.resumeErrors = true;

		interp.errorHandler = (error) -> {
			FlxG.stage.window.alert(error.toString(), 'HScript error');
		};

		expr = parser.parseString(Paths.getText(path), path);
	}

	override function setParent(parent:Dynamic) {
		interp.scriptObject = parent;
	}

	override function run():Any {
		return interp.execute(expr);
	}

	override function set(name:String, value:Any) {
		interp.variables[name] = value;
	}

	override function get(name:String):Null<Any> {
		return interp.variables.get(name);
	}

	override function call(name:String, args:Array<Dynamic>):Any {
		if (!interp.variables.exists(name)) return null;
		return Reflect.callMethod({}, interp.variables[name], args);
	}
}
