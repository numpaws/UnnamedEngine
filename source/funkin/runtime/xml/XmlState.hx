package funkin.runtime.xml;

import funkin.runtime.scripts.ScriptManager;
import funkin.runtime.scripts.Script;
import flixel.FlxG;
import flixel.FlxBasic;
import haxe.xml.Access;
import funkin.assets.Paths;
import flixel.addons.transition.FlxTransitionableState;

class XmlState extends FlxTransitionableState {
	var nodes:Map<String, FlxBasic> = [];
	var scripts = new ScriptManager();

	var name:String;

	public function new(name:String) {
		this.name = name;
		_constructor = () -> new XmlState(name);
		super();
	}

	override function create() {
		trace('Generating state from $name.xml file...');

		var xmlSource = Paths.getText('data/states/$name.xml');
		if (xmlSource != null) {
			var xml = new Access(Xml.parse(xmlSource).firstElement());
			if (xml.name.toLowerCase() != 'state') trace('Invalid class "${xml.name}", expected "state"');
			else for (node in XmlBuilder.build(xml, 'data/states')) {
				switch(node.type) {
					case TObject(id):
						if (id != null) nodes[id] = node.instance;
						add(node.instance);

					case TScript:
						var script:Script = node.instance;
						scripts.add(script);
						script.setParent(this);
						script.run();
				}
			}
		}

		// flixel.FlxG.state.openSubState(new funkin.runtime.xml.XmlSubState('test'));

		super.create();
	}

	override function update(elapsed:Float) {
		// if (FlxG.keys.justPressed.F5) FlxG.resetState();
		if (FlxG.keys.justPressed.F5) FlxG.switchState(() -> new XmlState(name));

		super.update(elapsed);
	}
}
