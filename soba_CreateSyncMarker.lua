--[[
 * ReaScript Name: Create Sync Marker
 * Author: soapy-bat
 * Repository: GitHub > soapy-bat > REAPER-Scripts
 * Repository URI: https://github.com/soapy-bat/REAPER-Scripts
 * Licence: GPL v3
 * REAPER: 7.09
 * Version: 1.0
]]


---------------
-- variables --
---------------

local r = reaper
local markerLabel = "SYNC"

---------------
-- functions --
---------------

function CreateSyncMarker()

  local numSelectedItems = r.CountSelectedMediaItems(0)
  
   -- Iterate through selected items
   for i = 0, numSelectedItems - 1 do

    -- Get the active media item
    local mediaItem = r.GetSelectedMediaItem(0, i)
    
    if mediaItem then
        -- Get the active take
        local activeTake = r.GetActiveTake(mediaItem)
    
        if activeTake then
            -- Remove existing MarkerLabel markers
            local numMarkers = r.GetNumTakeMarkers(activeTake)
            for i = numMarkers, 0, -1 do
                local _, markerType, _, _, _ = r.GetTakeMarker(activeTake, i)
                if markerType == markerLabel then
                    r.DeleteTakeMarker(activeTake, i)
                end
            end
    
            -- Get the relative cursor position within the active take
            local cursorPosInTake = r.GetCursorPosition() - r.GetMediaItemInfo_Value(mediaItem, "D_POSITION")
    
            -- Add a take marker at the cursor position
            r.SetTakeMarker(activeTake, -1, markerLabel, cursorPosInTake, 0)
    
            -- Update the arrangement
            r.UpdateArrange()
        end
    end
  end
end

---------------------------
-- execution starts here --
---------------------------

r.Undo_BeginBlock()
CreateSyncMarker()
r.Undo_EndBlock("Create Sync Marker", -1)
