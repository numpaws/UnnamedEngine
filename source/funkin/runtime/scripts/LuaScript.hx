package funkin.runtime.scripts;

import funkin.util.ReflectUtil;
import funkin.assets.Paths;
import vm.lua.Lua;

class LuaScript extends Script {
	var lua:Lua;
	var path:String;

	var parent:Dynamic;

	public function new(path:String) {
		super();

		lua = new Lua();

		this.path = path;
	}

	override function setParent(parent:Dynamic) {
		this.parent = parent;
	}

	override function run():Any {
		// trace(globals.keys());
		try {
			return lua.run(Paths.getText(path), {
				getVar: (variable:String) -> ReflectUtil.getVar(parent, variable),
				setVar: (variable:String, value:Any) -> ReflectUtil.setVar(parent, variable, value),

				getClassVar: (clazz:String, variable:String) -> ReflectUtil.getClassVar(clazz, variable),
				setClassVar: (clazz:String, variable:String, value:Any) -> ReflectUtil.setClassVar(clazz, variable, value),

				callMethod: (method:String, args:Array<Dynamic>) -> ReflectUtil.callMethod(parent, method, args),
				callClassMethod: (clazz:String, method:String, args:Array<Dynamic>) -> ReflectUtil.callClassMethod(clazz, method, args)
			});
		} catch(exception) {
			trace(exception);
			return null;
		}
	}

	override function set(name:String, value:Any) {
		lua.setGlobalVar(name, value);
	}

	override function get(name:String):Null<Any> {
		return lua.getGlobalVar(name);
	}

	override function call(name:String, args:Array<Dynamic>):Any {
		return lua.call(name, args);
	}
}
