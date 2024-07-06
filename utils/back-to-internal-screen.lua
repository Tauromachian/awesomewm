local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

-- Script to display the internal screen automatically if no
-- external screen is detected
local function check_displays()
    local internal_output = "eDP" -- Replace with your internal display name

    awful.spawn.easy_async_with_shell("xrandr --query", function(stdout)
        local external_connected = false

        for line in stdout:gmatch("[^\r\n]+") do
            if not line:match(internal_output) and line:match(" connected") then
                external_connected = true
                break
            end
        end

        if external_connected then
            return
        end

        -- No external monitor is connected, enable the internal output
        awful.spawn("xrandr --output " .. internal_output .. '-1' .. " --auto", false)
    end)
end

-- Run the function to check displays initially
check_displays()

-- You can set up a timer to check periodically or use udev rules for real-time changes
gears.timer {
    timeout = 10, -- Adjust the interval as needed
    autostart = true,
    callback = check_displays
}
