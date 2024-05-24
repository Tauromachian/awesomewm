local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')

local brightness_widget = wibox.widget {
    {
        id = "brightness_widget",
        text = "0%",
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal
}

local function update_brightness(widget)
    awful.spawn.easy_async('brightnessctl get', function(stdout)
        local brightness = tonumber(stdout)
        awful.spawn.easy_async('brightnessctl m', function(max_brightness_stdout)
            local maxBrightness = tonumber(max_brightness_stdout)

            local brightness_percent = math.floor(brightness * 100 / maxBrightness)

            widget:get_children_by_id("brightness_widget")[1].text = brightness_percent .. "%"
        end)
    end)
end

gears.timer {
    timeout = 10,
    autostart = true,
    callback = update_brightness
}

update_brightness(brightness_widget)

brightness_widget:buttons(
    gears.table.join(
        awful.button({}, 4, function() -- Scroll up to increase volume
            awful.spawn("brightnessctl set +10%")
            update_brightness(brightness_widget)
        end),
        awful.button({}, 5, function() -- Scroll down to decrease volume
            awful.spawn("brightnessctl set 10%-")
            update_brightness(brightness_widget)
        end)
    )
)

return brightness_widget
