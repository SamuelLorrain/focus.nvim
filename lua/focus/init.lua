local M = {}

M.should_check_for_focus_change = true
M._is_focus = false
M._focused_buffer_number = nil
M._focused_window = nil
M._cursor_position = {
    r = nil,
    c = nil
}

M._focus_has_changed = function()
    if M._is_focus == false then
        return false
    end
    local current_buffer_info = M._fetch_infos()
    if current_buffer_info.buffer_number ~= M._focused_buffer_number then 
        return true
    end
    if M._focused_window ~= vim.api.nvim_get_current_win() then
        return true
    end
    return false
end

M._reset_focus = function()
    M._is_focus = false
    M._focused_buffer_number = nil
    M._focused_window = nil
    M._has_changed_env = false
end

M._fetch_infos = function()
    local buffer_number = vim.api.nvim_get_current_buf()
    local current_win = vim.api.nvim_get_current_win()
    if buffer_number == nil then
        vim.notify("error: buffer uri is nil", vim.log.levels.ERROR)
        return {}
    end
    return {
        buffer_number = buffer_number,
        cursor_position = vim.api.nvim_win_get_cursor(current_win)
    }
end

M.focus_on = function()
    local info = M._fetch_infos()
    vim.cmd('tabnew')
    vim.api.nvim_set_current_buf(info.buffer_number)

    M._focused_window = vim.api.nvim_get_current_win()
    M._is_focus = true
    M._focused_buffer_number = info.buffer_number
    M._cursor_position = info.cursor_position

    vim.api.nvim_win_set_cursor(M._focused_window, M._cursor_position)
end

M.focus_off = function()
    if M.should_check_for_focus_change then
        local focus_has_changed = M._focus_has_changed()
        if focus_has_changed == false then
            vim.cmd('tabclose')
            M._reset_focus()
        else
            M._reset_focus()
            M.toggle_focus() -- recall toggle focus if the focus has changed
        end
    else
        M._reset_focus()
        vim.cmd('tabclose')
    end
end

M.toggle_focus = function()
    if M._is_focus then
        M.focus_off()
    else
        M.focus_on()
    end
end

M.setup = function(opts)
    opts = opts or {
        default_key_binding = true
    }
    if opts.should_check_for_focus_change then
        M.should_check_for_focus_change = opts.should_check_for_focus_change
    end

    vim.api.nvim_create_user_command("ToggleFocusMode", M.toggle_focus, {})

    if (opts.default_key_binding ~= false) or (opts.default_key_binding == nil)  then
        vim.keymap.set('n', '<leader>z', ':ToggleFocusMode<CR>', {})
    end
end

return M
