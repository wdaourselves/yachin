if(!SERVER)then return nil end

YACHIN = YACHIN or {}
YACHIN.Color = Color(0, 200, 0)

YACHIN.AUTH=YACHIN.AUTH or {}

YACHIN.AUTH.BlackList={	--; Догадайтесь почему
	"eliden",
	"_clue",
	"67th",
	"gleb",
	"_hram",
	"funmaps",
}

YACHIN.AUTH.WhiteList={}

YACHIN.AUTH.WhiteList[1]={
	"runstring(ex)",	--; По неизвестной причине не работает также, как на кете, приходиться делать это
	--; Это кто-то кто захочет объязательно заабузит
	
	"lua/ulx/",
	"lua/ulib/",
	"lua/includes/",
	"lua/autorun/server/roundalert",
	"lua/autorun/properties",
	-- "lua/autorun/list_map_mdl_vmt_sound.lua",
	
	"lua/autorun/sh_notepad.lua",
	
	-- "lua/wire",
	
	"addons/ulx/",
	"addons/ulib/",
	"addons/ulx_custom_commands",
	-- "addons/hmcd_effects/",
	"addons/atlaschat/",
	"addons/lua-misc/",
	"addons/gprofiler/",
	"addons/ulxsync/",
	"addons/customshit/",
	
	-- "addons/tfa",
	-- "addons/swarm",
	-- "addons/homicide",
	-- "addons/cubemap_switcher",
	-- "addons/survival/",
	
	"addons/homig2/",
	"addons/zbox_rp/",
	"addons/homigrad/",
	"addons/homigrad-weapons/",
	"addons/homigrad-otherweapons/",
	"addons/simfphys/",
	"addons/simfphys_extra_functions/",
	"addons/npcbase/",
	"addons/homigrad-discord-intergration/",
	"addons/igs-modification/",
	"addons/vfire-master/",
	"addons/zbase/",
	"addons/zippy_library",
	"lua/entities/wac_hc_base/",
	"lua/vj_base/",
	"lua/entities/npc_vj_l4d_com_male/",
	"lua/entities/npc_vj_creature_base/",

	"gamemodes/",
	"igs/",
	"lua/igs/",
	
	"lua/entities/lunasflightschool",
	
	
	-- "addons/machinners_seige/",
	-- "addons/machinners/",
	-- "lua/wuma/",
	"lua/libraries/sh_cami",
	
	-- Simpfhys shittt
	"lua/simfphys/",
	"lua/simfphysextra",
	"lua/entities/gmod_sent_vehicle_fphysics_base",

	-- "lua/entities/gballoon_base",
	-- "addons/gladium/",
	-- "lua/draconic/",
	"lua/autorun/lvs_init",
	"lua/autorun/vj_base_autorun.lua",
}

YACHIN.AUTH.WhiteList[2]={
	"addons/homicide",
	
	"gamemodes/",
}

YACHIN.AUTH.WhiteList[0]=table.Copy(YACHIN.AUTH.WhiteList[1])
--table.insert(YACHIN.AUTH.WhiteList[0],"lua/entities/lunasflightschool_basescript_heli/")

YACHIN.AUTH.Funcs=YACHIN.AUTH.Funcs or {}

function YACHIN:AcceptFunction(name,deb,level,...)
	local level_debug = 1
	local deniedline = nil

	while true do
		local info = debug.getinfo(level_debug, "Sln")
		
		if (!info) then
			break
		end
	
		local allowed = nil
		local line = string.format( "\t%i: Line %d\t\"%s\"\t\t%s", level_debug, info.currentline, info.name, info.short_src )
		
		if(string.find(string.lower(line),".lua"))then
			for _,p in pairs(YACHIN.AUTH.WhiteList[level])do
				local expline = info.short_src
				
				if(string.StartWith(string.lower(expline), p))then
					allowed=true
				end
			end
		else
			allowed=true
		end
		
		if(!allowed)then
			deniedline=line
		end

		level_debug = level_debug + 1
	end
	
	-- local exp = string.Explode("\n",string.lower(deb))
	-- local deniedline = nil
	
	-- for _,line in pairs(exp)do
		-- line=string.Trim(line)
		-- local allowed = nil
		
		-- if(string.find(string.lower(line),".lua:"))then
			-- for _,p in pairs(YACHIN.AUTH.WhiteList[level])do
				-- local expline = string.Explode(" ",string.lower(line))[1]
				
				-- if(string.StartWith(string.lower(expline),p))then
					-- allowed=true
				-- end
			-- end
		-- else
			-- allowed=true
		-- end
		
		-- if(!allowed)then
			-- deniedline=line
		-- end
	-- end
	
	if(deniedline)then
		hook.Run("Yachin_Unathorizedusage",name,deniedline,level,...)
		--YACHIN:NotifyAdmins("Unauthorized usage of ]]..name..[[ at "..deniedline)
		return false
	end
	
	return true
end

function YACHIN.AUTH:AuthFunction(name,level)
	RunString("YACHIN.AUTH.Funcs["..'"'..name..'"'.."]=YACHIN.AUTH.Funcs["..'"'..name..'"'.."] or "..name)
	--local func=_G[name]
	
	level=level or 1
	
	RunString([[function ]]..name..[[(...)
			if(YACHIN)then
				if(!YACHIN:AcceptFunction("]]..name..[[",deb,]]..level..[[,...))then
					return
				end
			end
			
			return YACHIN.AUTH.Funcs]].."["..'"'..name..'"'.."]"..[[(...)
		end
	]])
end

function YACHIN.AUTH:UnAuthFunction(name)
	RunString(name..[[= YACHIN.AUTH.Funcs]].."["..'"'..name..'"'.."]")
end

function YACHIN.AUTH:AuthClassFunctions(name,level,unauth)
	local class=_G[name]
	for id,func in pairs(class or {})do
		if(isfunction(func))then
			if(unauth)then
				YACHIN.AUTH:UnAuthFunction(name.."."..id)
			else
				YACHIN.AUTH:AuthFunction(name.."."..id,level)
			end
		end
	end
end

YACHIN_PlayerMeta = FindMetaTable('Player')
YACHIN.AUTH:AuthFunction("RunConsoleCommand")
YACHIN.AUTH:AuthFunction("YACHIN_PlayerMeta.Ban")
YACHIN.AUTH:AuthFunction("YACHIN_PlayerMeta.Kick")
YACHIN.AUTH:AuthFunction("game.KickID")
YACHIN.AUTH:AuthFunction("YACHIN_PlayerMeta.SendLua")
YACHIN.AUTH:AuthFunction("BroadcastLua")
YACHIN.AUTH:AuthFunction("YACHIN_PlayerMeta.ConCommand")

YACHIN.AUTH:AuthFunction("YACHIN_PlayerMeta.Ping")

timer.Simple(0,function()
	YACHIN.AUTH:AuthClassFunctions("ULib")
	YACHIN.AUTH:AuthClassFunctions("ulx")
	YACHIN.AUTH:AuthClassFunctions("file")

	YACHIN.AUTH:AuthFunction("ulx.logString",0)
	
	
	--YACHIN.AUTH:AuthClassFunctions("YACHIN")	--Self auth
	--YACHIN.AUTH:AuthClassFunctions("DOG")		--DOG auth
end)

--YACHIN.AUTH:UnAuthFunction("ulx.logString")

hook.Add("Yachin_Unathorizedusage","Yachin",function(name,deniedline,level,...)
	YACHIN:NotifyAdminsRational("Unauthorized usage of " .. name .. " at " .. (isstring(deniedline) and deniedline or "???"))
	--YACHIN:NotifyAdmins(level)
	MsgC( YACHIN.Color, YACHIN.Name..": Unauthorized usage of function ("..name..") at \n"..deniedline.."\nwith arguments of\n" )
	MsgC( YACHIN.Color, "-{" );MsgC( YACHIN.Color, ... );MsgC( YACHIN.Color, "}-" )
	Msg( "\n" )
end)
--YACHIN.AUTH.Funcs.RunConsoleCommand=YACHIN.AUTH.Funcs.RunConsoleCommand or RunConsoleCommand

--[[
function RunConsoleCommand(...)
	local deb = debug.traceback()
	for i,p in pairs(YACHIN.AUTH.BlackList)do
		if(string.find(string.lower(deb),p))then
			YACHIN:NotifyAdmins("Unauthorized usage of RunConsoleCommand in "..p)
			return
		end
	end
	YACHIN.AUTH.Funcs.RunConsoleCommand(...)
end]]