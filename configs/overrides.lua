local M = {}

M.treesitter = {
  ensure_installed = {
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- need at least one or configuration errors out
    "lua-language-server"
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return vim.tbl_deep_extend("force", M, vim.g.nvimrcj.overrides or {})
