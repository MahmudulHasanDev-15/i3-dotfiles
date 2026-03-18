local dap = require("dap")
local dapui = require("dapui")

-- Configure DAP UI
dapui.setup()

-- Example C++ DAP adapter (requires lldb)
dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode', -- adjust path if needed
  name = "lldb"
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}

-- Use same for C
dap.configurations.c = dap.configurations.cpp
