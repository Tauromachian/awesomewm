-- Load required libraries
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/battery/icons'

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
        id = "icon",
        widget = wibox.widget.imagebox,
        resize = true,
    },
    layout = wibox.layout.fixed.horizontal,
    set_battery = function(self, capacity, status, battery_tooltip)
        local batteryIconName = '/battery'

        if status == 'Charging' or status == 'Full' then
            batteryIconName = batteryIconName .. '-charging'
        end

        local roundedCapacity = math.floor(capacity / 10) * 10

        if roundedCapacity == 100 then
            batteryIconName = batteryIconName .. '.svg'
        else
            batteryIconName = batteryIconName .. '-' .. roundedCapacity .. '.svg'
        end

        battery_tooltip.text = capacity .. '%'

        self:get_children_by_id("icon")[1]:set_image(PATH_TO_ICONS .. batteryIconName)
    end
}

local battery_tooltip = awful.tooltip(
    {
        objects = { battery_widget },
        mode = 'outside',
        align = 'left',
        preferred_positions = { 'right', 'left', 'top', 'bottom' }
    }
)

local function updateBatteryInfo()
    local capacity, status = read_battery_info()
    battery_widget:set_battery(capacity, status, battery_tooltip)
end

-- Update the battery widget every minute
gears.timer {
    timeout = 60,
    autostart = true,
    callback = updateBatteryInfo
}
updateBatteryInfo()

return battery_widget
