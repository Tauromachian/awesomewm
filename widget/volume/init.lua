-- Load the necessary Awesome libraries
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local create_slider = require("widget.generic.slider")
local slider = create_slider()

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/volume/icons/'

-- Create the volume widget
local volume_widget = wibox.widget {
    {
        id = "icon",
        image = PATH_TO_ICONS .. 'volume-high.svg', -- Path to volume icon
        widget = wibox.widget.imagebox,
    },
    layout = wibox.layout.fixed.horizontal,
}

local wifi_popup = awful.popup {
    widget = {
        {
            {
                text   = 'Volume',
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
wifi_popup.parent = volume_widget

local function update_volume(widget)
    awful.spawn.easy_async("amixer get Master", function(stdout)
        local volume = string.match(stdout, "(%d?%d?%d)%%")
        volume = tonumber(volume)
        widget.value = volume
    end)
end

volume_widget:buttons(
    gears.table.join(
        awful.button({}, 1, function()
            awful.placement.next_to(volume_popup,
                {
                    preferred_positions = { "bottom" },
                    preferred_anchors = { "back" },
                }
            )
            volume_popup.visible = not volume_popup.visible
        end)
    )
)

update_volume(slider)
slider:connect_signal('property::value', function(widget)
    awful.spawn("amixer set Master " .. widget.value .. "%")
end)


-- Return the widget so it can be added to the wibox
return volume_widget
