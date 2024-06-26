local wibox           = require("wibox")
local awful           = require("awful")
local gears           = require("gears")

local keyboard_layout = wibox.widget {
    id = "text_role",
    text = "us",
    widget = wibox.widget.textbox,
}

awful.spawn.easy_async("setxkbmap -query", function(stdout)
    local layout = stdout:match("layout:%s+(%w+)")
    keyboard_layout.text = " " .. layout .. " "
end)

local function set_keyboard_layout()
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
end

keyboard_layout:buttons(
    gears.table.join(
        awful.button({}, 1, set_keyboard_layout)
    )
)

return { keyboard_layout = keyboard_layout, set_keyboard_layout = set_keyboard_layout }
