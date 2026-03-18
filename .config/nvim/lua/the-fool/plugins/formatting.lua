return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        cpp = { "clang-format" }, -- গেম কোডিংয়ের জন্য সবথেকে দরকারি
        c = { "clang-format" },
        cmake = { "cmake_format" },
        python = { "isort", "black" },
        markdown = { "prettier" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000, -- ৩০০০ms অনেক বেশি, ১০০০ms যথেষ্ট
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range" })
  end,
}
