/**********************************************************************************
* ElecHive by KrX
* This plugin electrifies the Alien Hive in Combat
* This is to balance some servers having more marine-sided plugins.
* Marines cannot receive resupply for ammo while getting electrocuted as
* the damage from the electricity will keep giving health instead
* Also allows for aliens to more easily take down hive gheyers
* 
* Special Thanks: 	DDR Khat, for his Anti-Lame CC & help with AvA, MvM & CVAR activation in v1.2
*		 	#endgame, for his #tryinclude template
*
* Changelog		v1.0
*			-> Initial Release
*			v1.1
*			-> Removed the need for fakemeta (thanks Morpheus!)
*			v1.2
*			-> Added MvM check, AvA check (and option), slightly optimized coding (thanks DDR Khat!)
*
* CVARs: 		amx_elechive (off: 0, on: 1, on except for AvA: 2)
*			(default:1)
*
* Defines:		HELPER (default:1) <- If you are using -mE-'s Helper, change this to 1, else 0.
*
*
* Upcoming Releases:	-> To add a timer for the electrification
*
***********************************************************************************/

#define HELPER 1	// 1 if Helper is running, 0 if not.

#include <amxmodx>
#include <amxmisc>
#include <ns>
#include <engine>

#if HELPER == 1
#tryinclude <helper>
#if !defined(HELPER_INC)
#error Cannot find helper.inc . Either set #define HELPER 0 or get helper from http://www.nsmod.org/forums/index.php?showtopic=3784
#endif
#endif

new plugin_version[] = "1.2"

public plugin_init() {
	register_cvar("KrX_elechive",plugin_version,FCVAR_SERVER)
	register_cvar("amx_elechive","1")
	// if ( ns_get_build("team_hive", 0, 0) < 2 &&  ns_is_combat() ) Don't need this anymore...
	if(get_cvar_num("amx_elechive") == 2 && ns_get_build("team_hive", 0, 0) > 1)
	{
		register_plugin("ElecHive (off)", plugin_version, "KrX")
		server_print("[ElecHive by KrX v %d] Aliens vs Aliens; disabling ElecHive.", plugin_version)
		pause("ad")
		return
	}
	else if( ns_is_combat() && ns_get_build("team_command", 0, 0) < 2) // Let's make sure it's neither, for both eventualities.
	{
		register_plugin("ElecHive", plugin_version, "KrX")
		register_event("Countdown", "NewCountdown", "ab")
		server_print("[ElecHive by KrX v %d] version %s Loaded succesfully!", plugin_version, plugin_version)
	}
	else
	{
		register_plugin("ElecHive (off)", plugin_version, "KrX")
		server_print("[ElecHive by KrX v %d] map is classic mode; disabling ElecHive.", plugin_version)
		pause("ad")
		return	
	}
}

public NewCountdown()
{
	// new enabled = get_cvar_num("max_elechive")	Don't need THIS anymore...
	// new hive = find_ent_by_class(1, "team_hive")	Don't need -THIS- anymore...
	new multihive
	if(get_cvar_num("amx_elechive")>0)
	{
		while ((multihive = find_ent_by_class(multihive, "team_hive")))
		{
			ns_set_mask(multihive, MASK_ELECTRICITY, 1)
		}
		client_print(0, print_chat, "[ElecHive by KrX] Hive(s) electrified!")
	}
	else
	{
		while ((multihive = find_ent_by_class(multihive, "team_hive")))
		{
			ns_set_mask(multihive, MASK_ELECTRICITY, 0)
		}
		client_print(0, print_chat, "[ElecHive by KrX] Hive(s) will not be electrified for this round.")
	}
}

// Helper Info
#if HELPER == 1					// if helper is running, see define HELPER
/************************************************
client_help( id )
Public Help System
************************************************/

public client_help(id)
{
  help_add("Information","This plugin electrifies the Alien Hive");
  help_add("Range","It will only electrocute players who are very near(near enough to knife)");
}

public client_advertise(id)
{
	return PLUGIN_CONTINUE;
}
#endif
