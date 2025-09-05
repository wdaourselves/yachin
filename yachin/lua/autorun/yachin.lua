if(SERVER)then
	local folder = "yachin/"
	
	include(folder .. "sv_authorized.lua")
	include(folder .. "sv_init.lua")
	include(folder .. "sv_triggers.lua")
end

if(CLIENT)then
	CreateClientConVar("yachin_debug_silence_level", 0, true, true, "Уровень молчания админа; 0 - Всё пишет, 1 - Молчание")
end

-- является файлом загрузки системы антибекдура из за полной некомпетентности разработчиков загружался одним из последних
-- комментарий от wdaourselves