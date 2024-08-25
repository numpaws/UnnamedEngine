package funkin.util;

class ReflectUtil {
	static function getArrayVar(instance:Dynamic, variable:String):Dynamic {
		var splitVars = variable.split('[');
		if (splitVars.length > 1) {
			var target:Dynamic = Reflect.field(instance, splitVars[0]);

			for (i in 1...splitVars.length) {
				var j:Dynamic = splitVars[i].substr(0, splitVars[i].length - 1);
				target = target[j];
			}
			return target;
		}

		if (Reflect.hasField(instance, 'get')) return instance.get(variable);
		return Reflect.field(instance, variable);
	}

	static function setArrayVar(instance:Dynamic, variable:String, value:Any):Dynamic {
		var splitVars = variable.split('[');
		if (splitVars.length > 1) {
			var target:Dynamic = Reflect.getProperty(instance, splitVars[0]);

			for (i in 1...splitVars.length) {
				var j:Dynamic = splitVars[i].substr(0, splitVars[i].length - 1);
				if (i >= splitVars.length-1) target[j] = value;
				else target = target[j];
			}
			return target;
		}

		if (Reflect.hasField(instance, 'set')) instance.set(variable, value);
		Reflect.setField(instance, variable, value);

		return value;
	}

	static function getVarLoop(instance:Dynamic, splitVars:Array<String>, getVar = true):Dynamic {
		var end = splitVars.length;
		if (getVar) end = splitVars.length - 1;

		var target = instance;
		for (i in 1...end) target = getArrayVar(target, splitVars[i]);
		return target;
	}

	public static function getVar(instance:Dynamic, variable:String):Dynamic {
		var splitVars = variable.split('.');
		if (splitVars.length > 1) return getArrayVar(getVarLoop(instance, splitVars), splitVars[splitVars.length - 1]);
		return getArrayVar(instance, variable);
	}

	public static function setVar(instance:Dynamic, variable:String, value:Any):Dynamic {
		var splitVars = variable.split('.');
		if (splitVars.length > 1) return setArrayVar(getVarLoop(instance, splitVars), splitVars[splitVars.length - 1], value);
		else return setArrayVar(instance, variable, value);
	}

	public static function getClassVar(clazz:String, variable:String):Dynamic {
		var resolvedClass:Dynamic = Type.resolveClass(clazz);
		if (resolvedClass == null) {
			trace('Class $clazz does not exist');
			return null;
		}

		var splitVars = variable.split('.');
		if (splitVars.length > 1) {
			var target:Dynamic = getArrayVar(resolvedClass, splitVars[0]);
			for (i in 1...splitVars.length - 1) target = getArrayVar(target, splitVars[i]);

			return getArrayVar(target, splitVars[splitVars.length - 1]);
		}
		return getArrayVar(resolvedClass, variable);
	}

	public static function setClassVar(clazz:String, variable:String, value:Any):Dynamic {
		var resolvedClass = Type.resolveClass(clazz);
		if (resolvedClass == null) {
			trace('Class $clazz does not exist');
			return null;
		}

		var splitVars:Array<String> = variable.split('.');
		if (splitVars.length > 1) {
			var target:Dynamic = getArrayVar(resolvedClass, splitVars[0]);
			for (i in 1...splitVars.length - 1) target = getArrayVar(target, splitVars[i]);

			return setArrayVar(target, splitVars[splitVars.length - 1], value);
		}
		return setArrayVar(resolvedClass, variable, value);
	}

	public static function callMethod(instance:Dynamic, name:String, args:Array<Dynamic>):Dynamic {
		var func = getVar(instance, name);
		if (func == null) return null;

		return Reflect.callMethod(instance, func, args ?? []);
	}

	public static function callClassMethod(clazz:String, name:String, args:Array<Dynamic>):Dynamic {
		var func = getClassVar(clazz, name);
		if (func == null) return null;

		return Reflect.callMethod(Type.resolveClass(clazz), func, args ?? []);
	}
}
