local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local beautiful = require("beautiful")

local create_slider = require("widget.gen.slider")
local slider = create_slider()

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/brightness/icons/'

local brightness_widget = wibox.widget {
    {
        id = "icon",
        image = PATH_TO_ICONS .. 'brightness-7.svg', -- Path to volume icon
        widget = wibox.widget.imagebox,
    },
    layout = wibox.layout.fixed.horizontal
}

local brightness_popup = awful.popup {
    widget = {
        {
            {
                text   = 'Brightness',
                widget = wibox.widget.textbox
            },
            {
                value         = 0.5,
                forced_height = 30,
                forced_width  = 200,
                widget        = slider,
            },
            layout = wibox.layout.fixed.vertical,
        },
        margins = 10,
        widget  = wibox.container.margin
    },
    border_color = beautiful.border_color,
    border_width = 2,
    ontop = true,
    visible = false,
}
brightness_popup.parent = brightness_widget


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

brightness_widget:buttons(
    gears.table.join(
        awful.button({}, 1, function()
            awful.placement.next_to(brightness_popup,
                {
                    preferred_positions = { "bottom" },
                    preferred_anchors = { "back" },
                }
            )
            brightness_popup.visible = not brightness_popup.visible
        end)
    )
)

slider:connect_signal('property::value', function(widget)
    awful.spawn("brightnessctl set " .. widget.value .. "%")
end)

update_brightness(brightness_widget)

-- slider:buttons(
--     gears.table.join(
--         awful.button({}, 4, function()
--             slider.value = math.min(slider.value + 5, 100) -- Scroll up: increase value
--         end),
--         awful.button({}, 5, function()
--             slider.value = math.max(slider.value - 5, 0) -- Scroll down: decrease value
--         end)
--     )
-- )


return brightness_widget
