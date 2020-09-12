/*  Summer-KillRewards
 *
 *  Copyright (C) 2020 SUMMER SOLDIER
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

#include <sourcemod>
#include <sdktools>

int killCounter[MAXPLAYERS + 1];
ConVar gC_MinKillsForReward;
ConVar gC_sheild;
ConVar gC_tanade;
ConVar gC_healthshot;

public Plugin myinfo = {
    name = "Summer-KillRewards",
    author = "Summer Soldier",
    description = "Reward the player when he gets n no of kills",
    version = "1.0",
    url = "https://github.com/Summer-16"
}

public void OnPluginStart() {
    HookEvent("player_death", Event_PlayerDeath);
    HookEvent("round_start", Round_Start);
    gC_MinKillsForReward = CreateConVar("sm_KRminimumKills", "3", "on how many kills a player will be rewarded");
    gC_sheild = CreateConVar("sm_KRrewardSheild", "1", "sheild enabled in reward");
    gC_tanade = CreateConVar("sm_KRrewardTAnade", "1", "TA Nade enabled in reward");
    gC_healthshot = CreateConVar("sm_KRrewardHealthshot", "0", "healthshot enabled in reward");

    // Execute the config file, create if not present
    AutoExecConfig(true, "Summer-KillRewards");
}

public void Round_Start(Handle event,
    const char[] name, bool dB) {
    for (int i = 1; i <= MaxClients; i++) {
        if (IsValidClient(i)) {
            killCounter[i] = 0;
        }
    }
}

public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast) {

    int victim = GetClientOfUserId(event.GetInt("userid"));
    int attacker = GetClientOfUserId(event.GetInt("attacker"));

    if (victim && attacker && victim != attacker) {
        killCounter[attacker]++;
    }

    if (killCounter[attacker] == GetConVarInt(gC_MinKillsForReward)) {
        if (GetConVarInt(gC_sheild))
            GivePlayerItem(attacker, "weapon_shield");
        if (GetConVarInt(gC_healthshot))
            GivePlayerItem(attacker, "weapon_healthshot");
        if (GetConVarInt(gC_tanade))
            GivePlayerItem(attacker, "weapon_tagrenade");
        killCounter[attacker] = 0;
    }
}


bool IsValidClient(int client) {
    return (client > 0 && client <= MaxClients && IsClientInGame(client) && !IsFakeClient(client) && IsPlayerAlive(client));
}