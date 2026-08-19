return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_image_location = "float"
    end,
    keys = {
      { "<leader>mi", ":MoltenInit<CR>", desc = "Initialize Kernel" },
      { "<leader>ml", ":MoltenEvaluateLine<CR>", desc = "Evaluate Line" },
      { "<leader>mr", ":MoltenReevaluateCell<CR>", desc = "Re-evaluate Cell" },
      { "<leader>md", ":MoltenDelete<CR>", desc = "Delete Cell" },
      { "<leader>mo", ":MoltenShowOutput<CR>", desc = "Show Output" },
      { "<leader>mh", ":MoltenHideOutput<CR>", desc = "Hide Output" },
      { "<leader>mc", ":MoltenInterrupt<CR>", desc = "Interrupt Kernel" },
      -- Export outputs to the .ipynb file
      { "<leader>ms", ":MoltenExportOutput<CR>", desc = "Export Outputs to ipynb" },

      -- Import outputs from the .ipynb file
      { "<leader>mv", ":MoltenImportOutput<CR>", desc = "Import Outputs from ipynb" },

      -- Clear all outputs in the current buffer
      { "<leader>mx", ":MoltenDelete<CR>", desc = "Delete Cell Output" },

      -- Your new Visual selection mapping
      { "<leader>r", ":<C-u>MoltenEvaluateVisual<CR>", mode = "v", desc = "Evaluate Visual Selection" },

      -- Run the current Markdown code block your cursor is inside
      {
        "<leader>rc",
        function()
          local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          local start_line, end_line

          -- Search upwards for the opening backticks
          for i = cursor_line, 1, -1 do
            if lines[i]:match("^```%s*python") then
              start_line = i + 1
              break
            elseif lines[i]:match("^```") and i ~= cursor_line then
              break -- We hit the end of a previous block
            end
          end

          -- Search downwards for the closing backticks
          if start_line then
            for i = cursor_line, #lines do
              if lines[i]:match("^```") and i ~= start_line - 1 then
                end_line = i - 1
                break
              end
            end
          end

          -- Evaluate if we successfully found the block boundaries
          if start_line and end_line and start_line <= end_line then
            vim.fn.MoltenEvaluateRange(start_line, end_line)
          else
            vim.notify("Cursor is not inside a valid Python code block!", vim.log.levels.WARN)
          end
        end,
        desc = "Run current Python block",
      },

      -- The "Run All Blocks" function we made earlier
      {
        "<leader>ma",
        function()
          local buf = vim.api.nvim_get_current_buf()
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          local start_line = nil

          for i, line in ipairs(lines) do
            if line:match("^```%s*python") then
              start_line = i + 1
            elseif line:match("^```") and start_line then
              local end_line = i - 1
              if start_line <= end_line then
                vim.fn.MoltenEvaluateRange(start_line, end_line)
              end
              start_line = nil
            end
          end
        end,
        desc = "Run all Python blocks",
      },
      -- function to register the ipykernel:window_overlap_clear_ft_ignore
      {
        "<leader>mk",
        function()
          -- Prompt the user for the kernel name
          vim.ui.input({ prompt = "Enter a display name for this Kernel: " }, function(display_name)
            if not display_name or display_name == "" then
              vim.notify("Kernel registration cancelled.", vim.log.levels.WARN)
              return
            end

            -- Convert the display name into a safe internal system name (lowercase, dashes)
            local internal_name = display_name:lower():gsub("%s+", "-"):gsub("[^a-z0-9%-]", "")

            vim.notify("Registering kernel: " .. display_name .. "...", vim.log.levels.INFO)

            -- Build and execute the shell command
            local cmd = string.format(
              'python -m ipykernel install --user --name="%s" --display-name="%s"',
              internal_name,
              display_name
            )
            local output = vim.fn.system(cmd)

            -- Check if it succeeded
            if vim.v.shell_error == 0 then
              vim.notify(
                "Kernel '" .. display_name .. "' registered successfully! Run :MoltenInit to see it.",
                vim.log.levels.INFO
              )
            else
              vim.notify(
                "Failed to register kernel. Did you run 'pip install ipykernel' in this environment?\nError details: "
                  .. output,
                vim.log.levels.ERROR
              )
            end
          end)
        end,
        desc = "Register current Python env as Jupyter Kernel",
      },
    },
  },
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      max_width = 150,
      max_height = 60,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
}
