local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

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

return slider
