--------------------------------------------------------------------------------------------------
-----------------------------------------   LibLogos   --------------------------------------------
---------------------------   by Deome (@deome) - heydeome@gmail.com   ---------------------------
local									VERSION = "1.01"										--
--																								--
--																								--
--------------------------------------   Obligatory Spam   ---------------------------------------
--																								--
-- 		"This Add-on is not created by, affiliated with or sponsored by ZeniMax 		  		--
--		Media Inc. or its affiliates. The Elder Scrolls® and related logos are registered 	 	--
--		trademarks of ZeniMax Media Inc. in the United States and/or other countries. 			--
--		All rights reserved."																	--
--																								--
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------
-----------------------------------------   Globals   --------------------------------------------
--------------------------------------------------------------------------------------------------

local MAJOR, MINOR = "LibLogos", 2
local LibLogos, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not LibLogos then return end

function LibLogos:SortTable() 			end
function LibLogos:ClearTable() 			end
function LibLogos:CountTable() 			end
function LibLogos:WeightedAverage()		end
function LibLogos:Round()				end
function LibLogos:RoundTo100s()			end
function LibLogos:YearsToSeconds()  	end
function LibLogos:MonthsToSeconds() 	end
function LibLogos:WeeksToSeconds() 		end
function LibLogos:DaysToSeconds() 		end
function LibLogos:HoursToSeconds() 		end
function LibLogos:SecondsToYears() 		end
function LibLogos:SecondsToDays() 		end
function LibLogos:SecondsToWeeks() 		end
function LibLogos:SecondsToDays() 		end
function LibLogos:SecondsToHours() 		end


--------------------------------------------------------------------------------------------------
------------------------------------------   Logic   ---------------------------------------------
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
-----------------------------------------   Tables   ---------------------------------------------
--------------------------------------------------------------------------------------------------

function LibLogos:ClearTable(aTable, numericIndex)
	if numericIndex then
		for key = #aTable, 1, -1 do
			aTable[key] = nil
		end
		
		return aTable
	else
		for key in pairs(aTable) do
			aTable[key] = nil
		end
	
		return aTable
	end
end

function LibLogos:CountTable(aTable, deep)
    local keys = 0
    
	for key, value in pairs(aTable) do
		keys = keys + 1
		
		if deep then
			if type(value) == "table" then
				LibLogos:CountTable(value)
			end
		end
	end
		
    return keys
end

function LibLogos:SortTable(aTable, direction)
	if direction == "asc" then
		table.sort(aTable)
	elseif direction == "desc" then
		table.sort(aTable, function(a, b) return a<b end)
	end
	
	return aTable
end


--------------------------------------------------------------------------------------------------
----------------------------------------   Arithmetic   ------------------------------------------
--------------------------------------------------------------------------------------------------

function LibLogos:WeightedAverage(value, weight)													-- For further study: https://en.wikipedia.org/wiki/Weighted_arithmetic_mean#Mathematical_definition
	local Avg	= value / weight																	-- Gonna show my work using the same symbols as in the above definition:
	local wAvg 	= (Avg * weight) / weight															-- for reference, µ is the same as "Avg"
	
	return wAvg

--  µ = x₁ / w₁
--	µ = (x₁ * w₁) / w₁
--	( (x₁ * w₁) + (x₂ * w₂) + ... (x₉ * w₉) ) / (w₁ + w₂ + ... w₉)

-- ^^ Repeat for each value/weight pair (ie price/stack in a sale) ^^
end


--------------------------------------------------------------------------------------------------
-----------------------------------------   Currency   -------------------------------------------
--------------------------------------------------------------------------------------------------

function LibLogos:Round(value)
	return math.floor(value + 0.5) or 0
end

function LibLogos:RoundTo100s(value)
	value = math.floor(value * 100)
	value = value / 100

	return value or 0
end


--------------------------------------------------------------------------------------------------
-------------------------------------------   Time   ---------------------------------------------
--------------------------------------------------------------------------------------------------

function LibLogos:YearsToSeconds(years)																	
	years = tonumber(years)																		
	assert(type(years) == "number", 
	"Bad argument #1 to `YearsToSeconds' (number expected)")
	
	if years < 0 then																			
		years = years * (-1)
	end
	
	local seconds = years * 31556925.9747
	return seconds
end

function LibLogos:MonthsToSeconds(months)																	
	months = tonumber(months)																		
	assert(type(months) == "number", 
	"Bad argument #1 to `MonthsToSeconds' (number expected)")
	
	if months < 0 then																			
		months = months * (-1)
	end
	
	local seconds = months * 259200
	return seconds
end

function LibLogos:WeeksToSeconds(weeks)																	
	weeks = tonumber(weeks)																		
	assert(type(weeks) == "number", 
	"Bad argument #1 to `WeeksToSeconds' (number expected)")
	
	if weeks < 0 then																			-- Why would I bother adding a check for negative weeks?
		weeks = weeks * (-1)																	-- Simple: to reduce the frequency of UI errors originating between chair and keyboard.
	end
	
	local seconds = weeks * 604800																
	return seconds
end

function LibLogos:DaysToSeconds(days)																	
	days = tonumber(days)																		
	assert(type(days) == "number", 
	"Bad argument #1 to `DaysToSeconds' (number expected)")
	
	if days < 0 then																			
		days = days * (-1)																		
	end
	
	local seconds = days * 86400																
	return seconds
end

function LibLogos:HoursToSeconds(hours)
	hours = tonumber(hours)		
	assert(type(hours) == "number", 
	"Bad argument #1 to `HoursToSeconds' (number expected)")
	
	if hours < 0 then			
		hours = hours * (-1)				
	end
	
	local seconds = hours * 3600																
	return seconds
end

function LibLogos:SecondsToYears(seconds)	
	seconds = tonumber(seconds)
	assert(type(seconds) == "number", 
	"Bad argument #1 to `SecondsToYears' (number expected)")

	if seconds < 0 then																			
		seconds = seconds * (-1)
	end
	
	local years = seconds / 31556925.9747															
	return years
end

function LibLogos:SecondsToMonths(seconds)	
	seconds = tonumber(seconds)
	assert(type(seconds) == "number", 
	"Bad argument #1 to `SecondsToMonths' (number expected)")

	if seconds < 0 then																			
		seconds = seconds * (-1)
	end
	
	local months = seconds / 2592000															
	return months
end

function LibLogos:SecondsToWeeks(seconds)	
	seconds = tonumber(seconds)
	assert(type(seconds) == "number", 
	"Bad argument #1 to `SecondsToWeeks' (number expected)")

	if seconds < 0 then																			
		seconds = seconds * (-1)																
	end
	
	local weeks = seconds / 604800																
	return weeks
end

function LibLogos:SecondsToDays(seconds)	
	seconds = tonumber(seconds)
	assert(type(seconds) == "number", 
	"Bad argument #1 to `SecondsToDays' (number expected)")

	if seconds < 0 then																			
		seconds = seconds * (-1)																		
	end
	
	local days = seconds / 86400																
	return days
end

function LibLogos:SecondsToHours(seconds)	
	seconds = tonumber(seconds)
	assert(type(seconds) == "number", 
	"Bad argument #1 to `SecondsToHours' (number expected)")

	if seconds < 0 then																			
		seconds = seconds * (-1)
	end
	
	local hours = seconds / 3600																
	return hours
end

