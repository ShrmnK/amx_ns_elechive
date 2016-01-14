/**********************************************************************************
* ElecHive by KrX
* This plugin electrifies the Alien Hive in Combat
* This is to balance some servers having more marine-sided plugins.
* Marines cannot receive resupply for ammo while getting electrocuted as
* the damage from the electricity will keep giving health instead
* Also allows for aliens to more easily take down hive gheyers
* 
* Special Thanks: 	DDR Khat, for this Anti-Lame CC
*		 	#endgame, for his #tryinclude template
*
* Changelog		v1.0
*			-> Initial Release
*			v1.1
*			-> Removed the need for fakemeta (thanks Morpheus!)
*
* CVARs: 		amx_elechive (default:1) <- Enable or disable ElecHive
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

new plugin_version[] = "1.1"

public plugin_init() {
	register_cvar("KrX_elechive",plugin_version,FCVAR_SERVER)
	if ( ns_get_build("team_hive", 0, 0) < 2 &&  ns_is_combat() )
	{
		register_plugin("ElecHive", plugin_version, "KrX")
		register_event("Countdown", "NewCountdown", "ab")
		register_cvar("amx_elechive","1")
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
	new enabled = get_cvar_num("amx_elechive")
	new hive = find_ent_by_class(1, "team_hive")
	if( enabled == 1 )
	{
		client_print(0, print_chat, "[ElecHive by KrX] The hive is now electrified!")
		ns_set_mask(hive, MASK_ELECTRICITY, 1)
	}
	else
	{
		client_print(0, print_chat, "[ElecHive by KrX] The hive will not be electrified for this round.")
		ns_set_mask(hive, MASK_ELECTRICITY, 0)
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
  help_add("Range","It will only electrocute marines who are very near(near enough to knife)");
}

public client_advertise(id)
{
	return PLUGIN_CONTINUE;
}
#endif
