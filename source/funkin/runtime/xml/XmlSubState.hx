package funkin.runtime.xml;

import funkin.runtime.scripts.ScriptManager;
import funkin.runtime.scripts.Script;
import flixel.FlxG;
import haxe.xml.Access;
import funkin.assets.Paths;
import flixel.FlxBasic;
import flixel.FlxSubState;

class XmlSubState extends FlxSubState {
	var nodes:Map<String, FlxBasic> = [];
	var scripts = new ScriptManager();

	var name:String;

	public function new(name:String) {
		this.name = name;
		super();
	}

	override function create() {
		trace('Generating substate from $name.xml file...');

		var xmlSource = Paths.getText('data/substates/$name.xml');
		if (xmlSource != null) {
			var xml = new Access(Xml.parse(xmlSource).firstElement());
			if (xml.name.toLowerCase() != 'substate') trace('Invalid class "${xml.name}", expected "substate"');
			else for (node in XmlBuilder.build(xml, 'data/substates')) {
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

		super.create();
	}

	override function update(elapsed:Float) {
		if (FlxG.keys.justPressed.F5) {
			/*if (FlxG.keys.pressed.SHIFT) FlxG.resetState();
			else*/ {
				var state = _parentState;
				if (state.subState == this) {
					close();
					state.openSubState(new XmlSubState(name));
				}
			}
		}

		super.update(elapsed);
	}
}
