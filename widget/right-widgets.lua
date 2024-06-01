local wibox = require("wibox")
local awful = require("awful")

local battery_widget = require('widget.battery')
local volume_widget = require('widget.volume')
local brightness_widget = require('widget.brightness')
local text_clock = require("widget.clock")

local function make_right_widgets(s)
    return {
        layout = wibox.layout.fixed.horizontal,
        spacing = 10,
        {

            wibox.widget.systray(),
            widget = wibox.container.margin,
            left = 3,
            right = 3,
            top = 3,
            bottom = 3,
        },
        {
            battery_widget,
            widget = wibox.container.margin,
            left = 3,
            right = 3,
            top = 3,
            bottom = 3,
        },
        {
            volume_widget,
            widget = wibox.container.margin,
            left = 3,
            right = 3,
            top = 3,
            bottom = 3,
        },
        {
            brightness_widget,
            widget = wibox.container.margin,
            left = 3,
            right = 3,
            top = 3,
            bottom = 3,
        },

        text_clock,
        {
            awful.widget.keyboardlayout(),
            widget = wibox.container.margin,
            bottom = 2,
        },
        s.mylayoutbox,
    }
end

return make_right_widgets
