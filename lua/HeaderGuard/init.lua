local M = {}

function M.generate_macro(name)
    local with_underscores = name:gsub("(%u)", "_%1")
    with_underscores = with_underscores:gsub("^_", "")
    return with_underscores:gsub("[^%w]", "_"):upper()
end

function M.insertGuard()
    -- get filename and sanitize
    local filename = vim.fn.expand("%:t")
    local guard = M.generate_macro(filename);

    -- check if guard already exists anywhere in the file
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for _, line in ipairs(lines) do
        if line:match(guard) then
            print("Header guard already exists: " .. guard)
            return
        end
    end

    vim.api.nvim_buf_set_lines(0, 0, 0, false, {
        "#ifndef " .. guard,
        "#define " .. guard,
        "",
        "",
    })

    local line_count = vim.api.nvim_buf_line_count(0)
    vim.api.nvim_buf_set_lines(0, line_count, line_count, false, {
        "",
        "#endif"
    })
    print("Header guard inserted: " .. guard)
end

return M;
