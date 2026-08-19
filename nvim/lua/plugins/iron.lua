return {
  "Vigemus/iron.nvim",
  main = "iron.core",
  config = function()
    local iron = require("iron.core")

    iron.setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,

        -- Define the REPL executable for Python
        repl_definition = {
          python = {
            -- We use ipython for the pretty outputs, history, and VS Code feel
            command = { "ipython", "--no-autoindent" },
          },
        },

        -- How the REPL window will be displayed (vertical split on the right, taking up 40% of the screen)
        repl_open_cmd = "vertical botright 40 split",
      },
    })

    -- ==========================================
    -- 1. Standard REPL Management Keymaps (Using <leader>i for Iron)
    -- ==========================================
    vim.keymap.set("n", "<leader>is", "<cmd>IronRepl<cr>", { desc = "Start Iron REPL", silent = true })
    vim.keymap.set("n", "<leader>ir", "<cmd>IronRestart<cr>", { desc = "Restart Iron REPL", silent = true })
    vim.keymap.set("n", "<leader>if", "<cmd>IronFocus<cr>", { desc = "Focus Iron REPL", silent = true })
    vim.keymap.set("n", "<leader>ih", "<cmd>IronHide<cr>", { desc = "Hide Iron REPL", silent = true })
    -- Run current line and step down to the next line
    vim.keymap.set("n", "<leader>in", function()
      iron.send_line()
      vim.cmd("normal! j") -- Moves cursor down one row
    end, { desc = "Iron: Step line-by-line", silent = true })
    -- ==========================================
    -- 2. Send Code Keymaps
    -- ==========================================
    vim.keymap.set("v", "<leader>iv", function()
      iron.visual_send()
    end, { desc = "Iron: Run visual selection", silent = true })
    vim.keymap.set("n", "<leader>il", function()
      iron.send_line()
    end, { desc = "Iron: Run current line", silent = true })

    -- Inspect variable under cursor (using the implicit print feature of IPython)
    vim.keymap.set("n", "<leader>ix", function()
      local var_name = vim.fn.expand("<cword>")
      iron.send("python", { var_name })
    end, { desc = "Iron: Inspect variable under cursor", silent = true })
    -- ==========================================
    -- 3. VS Code Style "Run Cell" (# %%) Logic
    -- ==========================================
    local function send_current_cell()
      local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

      local start_line = 1
      local end_line = #lines

      -- Find the start of the cell (searching upwards for # %%)
      for i = r, 1, -1 do
        if string.match(lines[i], "^# %%%%") then
          start_line = i
          break
        end
      end

      -- Find the end of the cell (searching downwards for the next # %%)
      for i = r + 1, #lines do
        if string.match(lines[i], "^# %%%%") then
          end_line = i - 1
          break
        end
      end

      -- If the start line is the marker, we start from start_line to exclude it
      -- (Since nvim_buf_get_lines is 0-indexed and end-exclusive)
      local start_idx = start_line - 1
      if string.match(lines[start_line], "^# %%%%") then
        start_idx = start_line
      end

      local cell_text = vim.api.nvim_buf_get_lines(0, start_idx, end_line, false)

      -- Append an empty string to simulate pressing "Enter" twice on multi-line blocks
      table.insert(cell_text, "")

      -- Send it to the Iron REPL
      iron.send("python", cell_text)
    end
    vim.keymap.set("n", "<leader>ic", send_current_cell, { desc = "Iron: Run current cell (# %%)", silent = true })
  end,
}
