#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

int g_iVelocity = -1;
bool inUse[MAXPLAYERS+1];

public Plugin myinfo = {
	name = "Parachute",
	author = "",
	description = "Добавляет парашют (точнее медленное падение но это типо парашют).",
	version = "1",
	url = ""
}

public void OnPluginStart()
{
	g_iVelocity = FindSendPropInfo("CBasePlayer", "m_vecVelocity[0]");
}
public void StartPara(int client, bool open)
{
	if (client < 1)
		return;
	
	float velocity[3];	
	
	if (g_iVelocity == -1) return;
	
	GetEntDataVector(client, g_iVelocity, velocity);
	if(velocity[2] < 0.0)
	{
		velocity[2] = -100.0;
		
		SetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", velocity);
		SetEntDataVector(client, g_iVelocity, velocity);
	}
}

public void Check(int client)
{
	if (client < 1)
		return;
	
	float speed[3];
	
	GetEntDataVector(client,g_iVelocity,speed);
	int cl_flags = GetEntityFlags(client);
	if(speed[2] >= 0 || (cl_flags & FL_ONGROUND)) inUse[client]=false;
}

public void OnGameFrame()
{
	int x;
	
	for (x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsPlayerAlive(x))
			{
				int cl_buttons = GetClientButtons(x);

				if (cl_buttons & IN_USE)
				{
					if (!inUse[x])
					{
						inUse[x] = true;
						StartPara(x,true);
					}
					StartPara(x,false);
				}
				else
				{
					if (inUse[x])
					{
						inUse[x] = false;
					}
				}
				Check(x);
			}
	}
}