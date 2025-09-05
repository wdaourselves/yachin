if(!SERVER)then return nil end

YACHIN=YACHIN or {}

YACHIN.DogFools=0
YACHIN.NextDogFools=0
YACHIN.DogFoolsCD=20

YACHIN.NextDogFoolsCheck=0
YACHIN.DogFoolsCheckCD=1

YACHIN.MonitorFuncs={
	["YACHIN"]=function()
		if(YACHIN.Moves>5)then
			YACHIN.Moves=0
			YACHIN.PublicName="Yachin"
			YACHIN:Say("Maybe i was wrong after all..")
			YACHIN:NotifyAdmins("Terminating myself in 10 seconds")
			timer.Simple(10,function()
				YACHIN:Say("I'm out")
				YACHIN:TerminateModule("YACHIN")
			end)
		end
	end,

--[[
	["DOG"]=function()
		if(YACHIN.NextDogFools and YACHIN.NextDogFools<=CurTime())then
			YACHIN.NextDogFools=CurTime()+YACHIN.DogFoolsCD
			YACHIN.DogFools=math.max(YACHIN.DogFools-1,0)
		end
		
		if(YACHIN.NextDogFoolsCheck<=CurTime())then
			YACHIN.NextDogFoolsCheck=CurTime()+YACHIN.DogFoolsCheckCD
			if(DOG and DOG.ACrash.CPSAll>1200)then
				YACHIN.DogFools=(YACHIN.DogFools or 0)+1
			end
		end
		
		if(YACHIN.DogFools>20)then
			DOG.ACrash.AI:Guess(game.GetMap(),"up",YACHIN.DogFools)
			YACHIN.NextDogFools=nil
			YACHIN.DogFools=0
			YACHIN:Say("Dog was a cool.. dog..")
			YACHIN:TerminateModule("DISABLE_DOG")
			--YACHIN:TerminateModule("DOG")
		end
	end,
]]
}

hook.Add("Think","YACHIN",function()
	if(YACHIN.Con_Disable and YACHIN.Con_Disable:GetBool())then return nil end
	
	for id,func in pairs(YACHIN.MonitorFuncs)do
		func()
	end
end)