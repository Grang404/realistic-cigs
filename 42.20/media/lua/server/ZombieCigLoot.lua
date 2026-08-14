if isClient() then
	return
end

local MOD = "RealisticCigs"

local function opt(name, default)
	if SandboxVars and SandboxVars[MOD] and SandboxVars[MOD][name] ~= nil then
		return SandboxVars[MOD][name]
	end
	local flat = MOD .. "_" .. name
	if SandboxVars and SandboxVars[flat] ~= nil then
		return SandboxVars[flat]
	end
	return default
end

local function addLootToZombie(zombie)
	if not zombie then
		return
	end
	local inv = zombie:getInventory()
	if not inv then
		return
	end

	local globalChance = opt("GlobalChance", 40)
	if ZombRand(100) >= globalChance then
		return
	end

	local log = "[RealisticCigs] Loot added to zombie at "
		.. zombie:getSquare():getX()
		.. ","
		.. zombie:getSquare():getY()

	local roll = ZombRand(100)

	if roll < opt("CigarettePackChance", 15) then
		local pack = inv:AddItem("Base.CigarettePack")
		if pack then
			local count = ZombRand(opt("CigarettePackMin", 4), opt("CigarettePackMax", 19) + 1)
			pack:setUsedDelta(count / 20.0)
			log = log .. " | CigPack(" .. count .. ")"
		end
	elseif roll < 15 + opt("LighterChance", 10) then
		local lighter = inv:AddItem("Base.Lighter")
		if lighter then
			local uses = ZombRand(opt("LighterMin", 8), opt("LighterMax", 28) + 1)
			lighter:setUsedDelta(uses / 32.0)
			log = log .. " | Lighter(" .. uses .. ")"
		end
	elseif roll < 25 + opt("DisposableChance", 10) then
		local disp = inv:AddItem("Base.LighterDisposable")
		if disp then
			local uses = ZombRand(opt("DisposableMin", 3), opt("DisposableMax", 11) + 1)
			disp:setUsedDelta(uses / 12.0)
			log = log .. " | DispLighter(" .. uses .. ")"
		end
	elseif roll < 35 + opt("MatchesChance", 10) then
		local matches = inv:AddItem("Base.Matches")
		if matches then
			local uses = ZombRand(opt("MatchesMin", 5), opt("MatchesMax", 15) + 1)
			matches:setUsedDelta(uses / 20.0)
			log = log .. " | Matches(" .. uses .. ")"
		end
	end

	if log:find("|") then
		print(log)
	end
end

Events.OnZombieDead.Add(addLootToZombie)

print("[RealisticCigs] Loaded.")
