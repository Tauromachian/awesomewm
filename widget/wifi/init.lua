local wibox = require('wibox')
local awful = require('awful')
local beautiful = require("beautiful")
local gears = require('gears')

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/wifi/icons'

local wifi_widget = wibox.widget {
    {
        id = "icon",
        image = PATH_TO_ICONS .. '/wifi.svg', -- Path to WiFi icon
        widget = wibox.widget.imagebox,
        resize = true,
    },
    layout = wibox.layout.fixed.horizontal,
}

local wifi_popup = awful.popup {
    widget = {
        {
            {
                id = "text_role",
                text = "WiFi status",
                widget = wibox.widget.textbox,
            },
            margins = 8,
            widget = wibox.container.margin,
        },
        bg = beautiful.bg_normal,
        widget = wibox.container.background,
    },
    border_color = beautiful.border_color,
    border_width = 2,
    ontop = true,
    visible = false,
    placement = function(c)
        awful.placement.next_to(c, {
            preferred_positions = { "top", "bottom", "left", "right" },
            preferred_anchors = { "middle", "front", "back" },
            geometry = wifi_widget:geometry(),
        })
    end,
}

wifi_widget:buttons(
    gears.table.join(
        awful.button({}, 1, function()
            wifi_popup.visible = not wifi_popup.visible
        end)
    )
)


return wifi_widget
