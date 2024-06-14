local function add_click_outside(widget)
    widget:connect_signal('mouse::leave', function()
        local mouse_coords = mouse.coords()
        local popup_geo = widget:geometry()

        if mouse_coords.x < popup_geo.x or mouse_coords.x > popup_geo.width + popup_geo.x or mouse_coords.y < popup_geo.y or mouse_coords.y > popup_geo.height + popup_geo.y then
            mousegrabber.run(function(mouse)
                local any_button_pressed = false
                for _, button_state in ipairs(mouse.buttons) do
                    if button_state then
                        any_button_pressed = true
                        break
                    end
                end

                if any_button_pressed then
                    widget.visible = false
                end

                return true
            end, 'arrow')
        end
    end)


    widget:connect_signal('mouse::enter', function()
        mousegrabber.stop()
    end)


    widget:connect_signal('property::visible', function()
        if not widget.visible then
            mousegrabber.stop()
        end
    end)
end


return add_click_outside
