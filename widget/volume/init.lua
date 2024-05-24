-- Load the necessary Awesome libraries
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

-- Create the volume widget
local volume_widget = wibox.widget {
    {
        id = "icon",
        image = "/usr/share/icons/Adwaita/16x16/status/audio-volume-medium-symbolic.symbolic.png", -- Path to volume icon
        widget = wibox.widget.imagebox,
    },
    {
        id = "volume_widget",
        text = "0%",
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
}

-- Function to update the widget
local function update_volume(widget)
    awful.spawn.easy_async("amixer get Master", function(stdout)
        local volume = string.match(stdout, "(%d?%d?%d)%%")
        volume = tonumber(volume)
        widget:get_children_by_id("volume_widget")[1].text = volume .. "%"
    end)
end

-- Set up a timer to update the widget periodically
gears.timer {
    timeout = 10,
    autostart = true,
    callback = function()
        update_volume(volume_widget)
    end
}

-- Update the volume immediately on startup
update_volume(volume_widget)

-- Add mouse buttons to control the volume
volume_widget:buttons(
    gears.table.join(
        awful.button({}, 4, function() -- Scroll up to increase volume
            awful.spawn("amixer set Master 5%+")
            update_volume(volume_widget)
        end),
        awful.button({}, 5, function() -- Scroll down to decrease volume
            awful.spawn("amixer set Master 5%-")
            update_volume(volume_widget)
        end)
    )
)

-- Return the widget so it can be added to the wibox
return volume_widget
