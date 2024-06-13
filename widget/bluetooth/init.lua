local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/bluetooth/icons/'

local bluetooth_app = require("apps").bluetooth

local bluetooth_widget = wibox.widget {
    {
        id = "icon",
        image = PATH_TO_ICONS .. 'bluetooth.svg', -- Path to volume icon
        widget = wibox.widget.imagebox,
    },
    layout = wibox.layout.fixed.horizontal
}


bluetooth_widget:buttons(
    gears.table.join(
        awful.button({}, 1, function()
            awful.spawn.easy_async(bluetooth_app)
        end)
    )
)

return bluetooth_widget
