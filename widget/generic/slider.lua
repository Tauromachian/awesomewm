local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")

local function make_slider()
    local slider = wibox.widget {
        bar_shape           = gears.shape.rounded_rect,
        bar_height          = 3,
        bar_color           = beautiful.border_color,
        handle_color        = beautiful.bg_normal,
        handle_shape        = gears.shape.circle,
        handle_border_color = beautiful.border_color,
        handle_border_width = 1,
        value               = 25,
        widget              = wibox.widget.slider,
    }

    slider:buttons(
        gears.table.join(
            awful.button({}, 4, function()
                slider.value = math.min(slider.value + 5, 100) -- Scroll up: increase value
            end),
            awful.button({}, 5, function()
                slider.value = math.max(slider.value - 5, 0) -- Scroll down: decrease value
            end)
        )
    )

    return slider
end


return make_slider
