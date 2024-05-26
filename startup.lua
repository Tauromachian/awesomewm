local awful = require('awful')

local startup_apps = {
    'blueman-applet',
    'nm-applet'
}

local function startup()
    for _, app in ipairs(startup_apps) do
        awful.spawn.easy_async(app)
    end
end

return startup
