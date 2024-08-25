package funkin.runtime;

import funkin.api.DiscordClient;
import flixel.FlxG;
import thx.semver.VersionRule;
import thx.semver.Version;
import haxe.Json;
import funkin.assets.BaseFileSystem;
import funkin.assets.Paths;

typedef ModConfig = {
	?engineVersion:VersionRule,
	?modVersion:Version
}

typedef ModDiscord = {
	?applicationID:String,
	?largeImage:String,
	?largeText:String
}

class Mod {
	static var fileSystem:BaseFileSystem;

	public static var config:ModConfig = {};
	public static var discord:ModDiscord = {};

	public static function initialize(path:String) {
		fileSystem = Paths.addFileSystem(path, true);

		if (fileSystem.exists('data/config.json')) config = Json.parse(fileSystem.getText('data/config.json'));
		if (fileSystem.exists('data/discord.json')) discord = Json.parse(fileSystem.getText('data/discord.json'));

		var currentVersion:Version = FlxG.stage.application.meta.get('version');
		if (!config.engineVersion?.isSatisfiedBy(currentVersion)) {
			var message = 'Engine version does not satisfy the mod request';
			FlxG.stage.window.alert(message, 'Version mismatch');
		}

		if (discord.applicationID != null) DiscordClient.initialize(discord.applicationID, discord.largeImage, discord.largeText);
	}
}
