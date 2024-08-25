package funkin.util;

import funkin.runtime.xml.XmlState;
import flixel.FlxG;
import flixel.math.FlxMath;

using StringTools;

@:forward
abstract CliCommand(RawCliCommand) {
	public function new(name:String, ?params:Array<String>, description:String, method:(Array<String>)->Void) {
		this = {
			name: name,
			params: params ?? [],
			description: description,
			method: method
		}
	}

	public function getHelpInfo(length:Int):String {
		var result = this.name;
		if (this.params.length > 0) result += '<${this.params.join(', ')}>';
		result = result.rpad(' ', length) + this.description;
		return result;
	}
}

typedef RawCliCommand = {
	name:String,
	params:Array<String>,
	description:String,
	method:(Array<String>)->Void
}

class CliUtil {
	static var commands:Array<CliCommand> = [
		new CliCommand('--help', 'Show this message', (params) -> {
			var length = 18;
			for (command in commands) length = FlxMath.maxInt(length, command.name.length);

			var message = 'Friday Night Funkin\' - Unnamed Engine ${FlxG.stage.application.meta.get('version')}\n';
			for (command in commands) message += command.getHelpInfo(length) + '\n';

			Sys.print(message);
			Sys.exit(0);
		}),
		new CliCommand('--xml', ['Name'], 'Force game to open state from xml', (params) -> {
			Main.initialState = () -> new XmlState(params[0]);
		})
	];

	public static function process() {
		var args = Sys.args();

		var name = args.shift();
		var params:Array<String> = [while (args.length > 0) args.shift()];

		for (command in commands) {
			if (command.name == name) {
				command.method(params);
				break;
			}
		}
	}
}
