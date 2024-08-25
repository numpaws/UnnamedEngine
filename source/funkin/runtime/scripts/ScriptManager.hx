package funkin.runtime.scripts;

class ScriptManager {
	var scripts:Array<Script> = [];

	public function new() {}

	public function add(script:Script) {
		scripts.push(script);
	}

	public function insert(pos:Int, script:Script) {
		scripts.insert(pos, script);
	}

	public function set(name:String, value:Any) {
		for (script in scripts) script.set(name, value);
	}

	public function call(name:String, args:Array<Dynamic>):Any {
		for (script in scripts) {
			var returned = script.call(name, args);
			if (returned != null) return returned;
		}
		return null;
	}
}
