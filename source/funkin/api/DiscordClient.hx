package funkin.api;

#if discord_rpc
import discord_rpc.DiscordRpc;
#end

class DiscordClient {
	static var presence:DiscordPresence;

	public static function initialize(applicationID:String, largeImage:String, largeText:String) {
		presence = {
			details: 'In the Menus',
			largeImageKey: largeImage,
			largeImageText: largeText
		}

		#if discord_rpc
		DiscordRpc.start({
			clientID: applicationID
		});
		pushPresence(presence);
		#elseif hldiscord
		discord.Api.init(applicationID, '');
		discord.Api.updateStartTimestamp(0);
		pushPresence(presence);
		#end
	}

	public static function changePresence(details:String, ?state:String, ?smallImageKey:String, hasStartTimestamp = false, endTimestamp = 0.0) {
		var startTimestamp = hasStartTimestamp ? Sys.time() : 0;
		if (endTimestamp > 0) endTimestamp += startTimestamp;

		presence.details = details;
		presence.state = state;
		presence.smallImageKey = smallImageKey;
		presence.startTimestamp = Math.floor(startTimestamp / 1000);
		presence.endTimestamp = Math.floor(endTimestamp / 1000);

		pushPresence(presence);
	}

	static function pushPresence(presence:DiscordPresence) {
		#if discord_rpc
		DiscordRpc.presence(presence);
		#elseif hldiscord
		discord.Api.updateState(presence?.state ?? '');
		discord.Api.updateDetails(presence?.details ?? '');
		discord.Api.updateStartTimestamp(presence?.startTimestamp ?? 0);
		discord.Api.updateEndTimestamp(presence?.endTimestamp ?? 0);
		discord.Api.updateLargeImageKey(presence?.largeImageKey ?? '');
		discord.Api.updateLargeImageText(presence?.largeImageText ?? '');
		discord.Api.updateSmallImageKey(presence?.smallImageKey ?? '');
		discord.Api.updateSmallImageText(presence?.smallImageText ?? '');
		discord.Api.updatePartySize(presence?.partySize ?? 0);
		discord.Api.updatePartyMax(presence?.partyMax ?? 0);
		discord.Api.updateMatchSecret(presence?.matchSecret ?? '');
		discord.Api.updateSpectateSecret(presence?.spectateSecret ?? '');
		discord.Api.updateJoinSecret(presence?.joinSecret ?? '');
		#end
	}
}

#if discord_rpc
typedef DiscordPresence = DiscordPresenceOptions;
#elseif hldiscord
typedef DiscordPresence = {
	?state:String,
	?details:String,
	?startTimestamp:Int,
	?endTimestamp:Int,
	?largeImageKey:String,
	?largeImageText:String,
	?smallImageKey:String,
	?smallImageText:String,
	?partyID:String,
	?partySize:Int,
	?partyMax:Int,
	?matchSecret:String,
	?spectateSecret:String,
	?joinSecret:String,
	?instance:Int
}
#end
