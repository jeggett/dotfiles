local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = true,
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
      })
      end,
  },
  {
    "mfussenegger/nvim-dap",
  },
  {
    "rcarriga/nvim-dap-ui",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  {
	  "catppuccin/nvim",
	  name = "catppuccin",
	  priority = 1000,
    config = function()
      require("catppuccin").setup({
        highlight_overrides = {
          macchiato = function(macchiato)
            return {
                LineNr = { fg = macchiato.overlay0 },
            }
          end,
        }
      })
      vim.cmd.colorscheme "catppuccin-macchiato"
    end,
  },
  {
    "p00f/clangd_extensions.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
      -- turn off temporarily
      -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local on_attach = function()
        require("clangd_extensions.inlay_hints").setup_autocmd()
        require("clangd_extensions.inlay_hints").set_inlay_hints()
      end
      lspc = require("lspconfig")
      lspc.clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspc.pyright.setup({})
    end,
  },
  { "folke/neodev.nvim", opts = {} },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  {
    "rcarriga/nvim-dap-ui"
  },
  {
    "theHamsta/nvim-dap-virtual-text"
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    config = function()
      require("telescope").load_extension('dap')
    end
  },
}


require("lazy").setup(plugins)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<M-1>', builtin.find_files, {})
vim.keymap.set('n', '<M-2>', builtin.live_grep, {})


vim.opt.tabstop = 4      -- Set the width of a tab to 4 spaces
vim.opt.shiftwidth = 4   -- Set the number of spaces to use for each step of (auto)indent
vim.opt.softtabstop = 4  -- Set the number of spaces that a <Tab> counts for while performing editing operations, like inserting a tab or using <BS>
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hidden = true -- for toggleterm

-- Create a group for the autocommands to avoid duplicates
local group = vim.api.nvim_create_augroup("MyFiletypeSettings", { clear = true })

-- Python settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  group = group,
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})

-- JavaScript settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  group = group,
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})


-- Lua settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  group = group,
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- Function to compile the current C file with clang
local function compile_current_c_file()
    -- Get the current buffer name (full path of the file)
    local bufname = vim.fn.expand('%:t')

    -- Extract the file name without extension
    local bufbname_wo_ext = bufname:match("(.+)%..+")

    -- Define the clang compile command with the output named after the source file
    local clang_command = "clang " .. bufname .. " -o " .. bufbname_wo_ext

    -- Execute the clang compile command

    vim.cmd('TermExec cmd="' .. clang_command .. " && ./" .. bufbname_wo_ext .. '"')
end


-- Set the hotkey Shift+F9 to the compile function
vim.keymap.set("n", "<F9>", compile_current_c_file, { noremap = true })
vim.keymap.set("i", "<F9>", compile_current_c_file, { noremap = true })
