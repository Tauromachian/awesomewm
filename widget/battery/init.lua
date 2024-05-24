-- Load required libraries
local wibox = require("wibox")
local gears = require("gears")

-- Function to read battery information
local function read_battery_info()
    local capacity = 0
    local status = "Unknown"
    local file

    -- Read battery capacity
    file = io.open("/sys/class/power_supply/BAT0/capacity", "r")
    if file then
        local capacityOrZero = tonumber(file:read("*all"))
        if capacityOrZero == nil then
            capacityOrZero = 0
        end

        capacity = capacityOrZero
        file:close()
    end

    -- Read battery status
    file = io.open("/sys/class/power_supply/BAT0/status", "r")
    if file then
        status = file:read("*all"):gsub("\n", "")
        file:close()
    end

    return capacity, status
end

-- Create the battery widget
local battery_widget = wibox.widget {
    {
        id = "text",
        widget = wibox.widget.textbox
    },
    layout = wibox.container.margin(nil, 5, 5, 5, 5),
    set_battery = function(self, capacity, status)
        self:get_children_by_id("text")[1]:set_text("Bat: " .. capacity .. "% (" .. status .. ")")
    end
}

local function updateBatteryInfo()
    local capacity, status = read_battery_info()
    battery_widget:set_battery(capacity, status)
end

-- Update the battery widget every minute
gears.timer {
    timeout = 60,
    autostart = true,
    callback = updateBatteryInfo
}
updateBatteryInfo()

return battery_widget
