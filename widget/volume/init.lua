-- Load the necessary Awesome libraries
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local make_slider = require("widget.generic.slider")
local make_popup = require("widget.generic.popup")

local slider = make_slider()

local volume_slider = {
    value         = 0.5,
    forced_height = 30,
    forced_width  = 200,
    widget        = slider,
}

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

local volume_popup = make_popup('Volume', volume_slider, volume_widget)

local function update_volume(widget)
    awful.spawn.easy_async("pactl get-sink-volume @DEFAULT_SINK@", function(stdout)
        local volume = stdout:match("(%d?%d?%d)%%")
        volume = tonumber(volume)
        widget.text = "Volume: " .. volume .. "%"
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
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ " .. widget.value .. "%")
end)


-- Return the widget so it can be added to the wibox
return volume_widget
