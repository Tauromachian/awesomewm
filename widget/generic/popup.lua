local wibox = require('wibox')
local awful = require('awful')
local beautiful = require("beautiful")

local function make_popup(title, content)
    local popup_widget = awful.popup {
        widget = {
            {
                {
                    text   = title,
                    widget = wibox.widget.textbox
                },
                content,
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

    return popup_widget
end


return make_popup
