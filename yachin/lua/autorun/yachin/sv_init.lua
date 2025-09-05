if(!SERVER)then return nil end
-- в комментариях текст снизу не нуждается. ( комментарий от wdaourselves )

--; Это не спасёт от очень умных людей, но хоть что-то

YACHIN=YACHIN or {}
YACHIN.PublicName=""
YACHIN.Name="Yachin"

YACHIN.Moves=YACHIN.Moves or 0

YACHIN.Con_Disable=CreateConVar("yachin_disable",0,FCVAR_ARCHIVE)

YACHIN.TerminateFuncs={
	--; HATE HATE HATE
	["YACHIN"]=function()
		local hooks = hook.GetTable()
		for cat,cont in pairs(hooks)do
			for id,func in pairs(cont)do
				if(string.find(tostring(id),"YACHIN"))then
					hook.Remove(cat,id)
					print(YACHIN.Name.." removed hook: "..cat.." "..id)
				end
			end
		end
		for id,func in pairs(YACHIN.AUTH.Funcs)do	
			RunString(id..[[=YACHIN.AUTH.Funcs]].."["..'"'..id..'"'.."]")
		end		
		YACHIN=nil
	end,

	["DISABLE_DOG"]=function()
		DOG.ACrash.Disabled=true
		DOG.ACrash.CPSAll=0
	end,

	["DOG"]=function()
		local hooks = hook.GetTable()
		for cat,cont in pairs(hooks)do
			for id,func in pairs(cont)do
				if(string.find(tostring(id),"DOG"))then
					hook.Remove(cat,id)
					print(YACHIN.Name.." removed hook: "..cat.." "..id)
				end
			end		
		end
		RunConsoleCommand("phys_timescale",1)
		DOG=nil
	end,
}

function YACHIN:Say(sentence)
	local msg = YACHIN.PublicName..": "..sentence
	PrintMessage(HUD_PRINTTALK, msg)
end

function YACHIN.NotifyAdminsRational(text)
	YACHIN.CheatMessagesTimes = YACHIN.CheatMessagesTimes or {}
	
	if(!YACHIN.CheatMessagesTimes[text] or YACHIN.CheatMessagesTimes[text] <= CurTime())then
		YACHIN.CheatMessagesTimes[text] = CurTime() + 10
	
		YACHIN:NotifyAdmins(text)
		
		return true
	end
end

function YACHIN:NotifyAdmins(text)
	for i,p in pairs(player.GetAll())do
		if(p:IsAdmin())then
			local notify = true
			local silence_level = p:GetInfoNum("yachin_debug_silence_level", 0)
			
			if(silence_level <= 0)then
				notify = true
			elseif(silence_level > 0)then
				notify = false
			end
			
			if(notify)then
				p:ChatPrint("[ADMINS]"..YACHIN.Name..": "..(isstring(text) and text or "??"))
			end
		end
	end
end

function YACHIN:TerminateModule(id)
	YACHIN:NotifyAdmins("Terminating "..id)
	YACHIN.Moves=YACHIN.Moves+1
	YACHIN.TerminateFuncs[id]()
end
