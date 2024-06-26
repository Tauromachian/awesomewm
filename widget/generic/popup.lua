local wibox = require('wibox')
local awful = require('awful')
local beautiful = require("beautiful")

local add_click_outside = require("utils.click_to_hide")

local function make_popup(title, content, parent)
    local popup_widget = awful.popup {
        widget       = {
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
        placement    = {},
        ontop        = true,
        visible      = false,
        parent       = parent
    }

    add_click_outside(popup_widget)

    return popup_widget
end


return make_popup
