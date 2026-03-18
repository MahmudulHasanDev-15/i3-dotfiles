return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "clangd",
        "lua_ls",
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "stylua", -- Lua formatting
        "clangd", -- Main C++ LSP (সবার আগে এটি লাগবে)
        "clang-format", -- C++ Code Formatter
        "neocmakelsp", -- CMake LSP
        "cmakelang", -- CMake Formatter/Linter
        "cpplint", -- C++ Linter
        "cpptools",
        "cmakelint",
      },
    },
  },
}
