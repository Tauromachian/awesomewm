local wibox = require('wibox')
local awful = require('awful')

local mytextclock = wibox.widget.textclock('%H:%M')

local month_calendar = awful.widget.calendar_popup.month({
    start_sunday = false,
    week_numbers = true
})

month_calendar:attach(mytextclock)

return mytextclock
