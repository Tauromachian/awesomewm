local function is_any_button_pressed(mouse)
    for _, button_state in ipairs(mouse.buttons) do
        if button_state then
            return true
        end
    end
end

local function get_click_inside_widget(widget)
    local mouse_coords = mouse.coords()
    local popup_geo = widget:geometry()

    if mouse_coords.x < popup_geo.x or mouse_coords.x > popup_geo.width + popup_geo.x or mouse_coords.y < popup_geo.y or mouse_coords.y > popup_geo.height + popup_geo.y then
        return false
    end

    return true
end

local function add_click_outside(widget)
    local function handle_click_outside(mouse, is_first_run)
        if is_first_run then
            return true
        end

        local is_inside_widget = get_click_inside_widget(widget)
        if is_inside_widget then
            return false
        end

        local any_button_pressed = is_any_button_pressed(mouse)
        if any_button_pressed then
            widget.visible = false
            return false
        end

        return true
    end

    widget:connect_signal('mouse::leave', function()
        mousegrabber.run(handle_click_outside, 'arrow')
    end)

    widget:connect_signal('property::visible', function()
        if widget.visible then
            local is_first_run = true

            mousegrabber.run(function(mouse)
                local status = handle_click_outside(mouse, is_first_run)

                if status then
                    is_first_run = false
                    return true
                end

                return false
            end
            , 'arrow')
        else
            mousegrabber.stop()
        end
    end)
end


return add_click_outside
