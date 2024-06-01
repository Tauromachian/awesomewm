local wibox           = require("wibox")
local awful           = require("awful")
local gears           = require("gears")

local keyboard_layout = wibox.widget {
    id = "text_role",
    text = "us",
    widget = wibox.widget.textbox,
}

local function update_keyboard_layout()
    awful.spawn.easy_async("setxkbmap -query", function(stdout)
        local layout = stdout:match("layout:%s+(%w+)")
        keyboard_layout.text = " " .. layout .. " "
    end)
end

keyboard_layout:buttons(
    gears.table.join(
        awful.button({}, 1, function()
            awful.spawn.easy_async("setxkbmap -query", function(stdout)
                local layout = stdout:match("layout:%s+(%w+)")
                local new_layout = ''

                if (layout == 'us') then
                    new_layout = 'es'
                else
                    new_layout = 'us'
                end

                awful.spawn("setxkbmap " .. new_layout, false)
                keyboard_layout.text = " " .. new_layout .. " "
            end)
        end)
    )
)

gears.timer {
    timeout   = 60,
    autostart = true,
    callback  = update_keyboard_layout
}
update_keyboard_layout()

return keyboard_layout
