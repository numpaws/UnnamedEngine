package funkin.runtime.xml;

import haxe.io.Path;
import funkin.runtime.scripts.Script;
import funkin.display.AtlasText;
import flixel.group.FlxGroup;
import flixel.text.FlxText.FlxTextBorderStyle;
import funkin.assets.Paths;
import flixel.math.FlxPoint;
import funkin.util.StringUtil;
import flixel.FlxSprite;
import funkin.display.AtlasSprite;
import haxe.xml.Access;

enum XmlNodeType {
	TObject(id:String);
	TScript;
}

typedef XmlNode = {
	type:XmlNodeType,
	instance:Dynamic
}

class XmlBuilder {
	public static function build(xml:Access, scriptsPath:String):Array<XmlNode> {
		var result:Array<XmlNode> = [];

		for (element in xml.elements) {
			switch(element.name.toLowerCase()) {
				case 'sprite' | 'sparrow':
					var node = {
						type: TObject(element.has.resolve('id') ? element.att.resolve('id') : null),
						instance: new AtlasSprite()
					}
					result.push(node);

					if (element.has.resolve('image')) node.instance.load(element.att.resolve('image'));
					buildSprite(node.instance, element);

				case 'box' | 'solid':
					var node = {
						type: TObject(element.has.resolve('id') ? element.att.resolve('id') : null),
						instance: new AtlasSprite()
					}
					result.push(node);

					if (element.has.resolve('color') && element.has.resolve('width') && element.has.resolve('height')) node.instance.makeGraphic(Std.parseInt(element.att.resolve('width')), Std.parseInt(element.att.resolve('height')), StringUtil.parseColor(element.att.resolve('color')));
					buildSprite(node.instance, element);

				case 'text' | 'label':
					var node = {
						type: TObject(element.has.resolve('id') ? element.att.resolve('id') : null),
						instance: new flixel.text.FlxText()
					}
					result.push(node);

					if (element.has.resolve('content')) node.instance.text = element.att.resolve('content');
					buildText(node.instance, element);

				case 'group' | 'container':
					var node = {
						type: TObject(element.has.id ? element.att.id : null),
						instance: new flixel.group.FlxContainer()
					}
					result.push(node);

					buildGroup(node.instance, element);

				case 'alphabet' | 'atlas-text':
					var node = {
						type: TObject(element.has.id ? element.att.id : null),
						instance: new AtlasText()
					}
					result.push(node);

					node.instance.font = element.has.font ? element.att.font : node.instance.font;
					if (element.has.content) node.instance.text = element.att.content;
					buildSprite(node.instance, element);

				case 'script':
					var node = {
						type: TScript,
						instance: Script.fromFile(Path.join([scriptsPath, element.att.resolve('path')]))
					}
					result.push(node);
			}
		}

		return result;
	}

	static function buildSprite(sprite:FlxSprite, xml:Access) {
		if (xml.has.resolve('x')) sprite.x = Std.parseFloat(xml.att.resolve('x'));
		if (xml.has.resolve('y')) sprite.y = Std.parseFloat(xml.att.resolve('y'));

		if (xml.has.resolve('alpha')) sprite.alpha = Std.parseFloat(xml.att.resolve('alpha'));
		if (xml.has.resolve('angle')) sprite.angle = Std.parseFloat(xml.att.resolve('angle'));
		if (xml.has.resolve('visible')) sprite.visible = xml.att.resolve('visible').toLowerCase() == 'true';

		if (xml.has.resolve('blend')) sprite.blend = xml.att.resolve('blend').toLowerCase();
		if (xml.has.resolve('antialiasing')) sprite.antialiasing = xml.att.resolve('antialiasing').toLowerCase() == 'true';

		if (xml.has.resolve('flipx')) sprite.flipX = xml.att.resolve('flipx').toLowerCase() == 'true';
		if (xml.has.resolve('flipy')) sprite.flipY = xml.att.resolve('flipy').toLowerCase() == 'true';

		if (xml.has.resolve('color')) sprite.color = StringUtil.parseColor(xml.att.resolve('color'));

		for (element in xml.elements) {
			switch(element.name.toLowerCase()) {
				case 'origin':
					buildPoint(sprite.origin, element);

				case 'offset':
					buildPoint(sprite.offset, element);

				case 'scale':
					buildPoint(sprite.scale, element);
			}
		}
	}

	static function buildPoint(point:FlxPoint, xml:Access) {
		if (xml.has.resolve('x')) point.x = Std.parseFloat(xml.att.resolve('x'));
		if (xml.has.resolve('y')) point.y = Std.parseFloat(xml.att.resolve('y'));
	}

	static function buildText(text:flixel.text.FlxText, xml:Access) {
		buildSprite(text, xml);

		if (xml.has.resolve('size')) text.size = Std.parseInt(xml.att.resolve('size'));
		if (xml.has.resolve('font')) text.font = Paths.font(xml.att.resolve('font'));
		if (xml.has.resolve('align')) text.alignment = xml.att.resolve('align').toLowerCase();
		if (xml.has.resolve('autosize')) text.autoSize = xml.att.resolve('autosize').toLowerCase() == 'true';

		for (element in xml.elements) {
			switch(element.name.toLowerCase()) {
				case 'border':
					if (element.has.resolve('style')) text.borderStyle = FlxTextBorderStyle.createByName(element.att.resolve('style').toUpperCase());
					if (element.has.resolve('color')) text.borderColor = StringUtil.parseColor(element.att.resolve('color'));
					if (element.has.resolve('size')) text.borderSize = Std.parseFloat(element.att.resolve('size'));
					if (element.has.resolve('quality')) text.borderQuality = Std.parseFloat(element.att.resolve('quality'));

				case 'shadowoffset':
					buildPoint(text.shadowOffset, element);
			}
		}
	}

	static function buildGroup(group:FlxGroup, xml:Access) {
		for (node in XmlBuilder.build(xml, null)) {
			switch(node.type) {
				case TObject(id):
					group.add(node.instance);

				default:
			}
		}
	}
}
