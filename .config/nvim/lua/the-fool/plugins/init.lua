return {
  "nvim-lua/plenary.nvim",
  "christoomey/vim-tmux-navigator",
  {
    "mfussenegger/nvim-dap",
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
  },
  {
    "Civitasv/cmake-tools.nvim",
    cmd = { "CMakeGenerate", "CMakeBuild", "CMakeRun" },
    opts = {
      cmake_command = "cmake",
      build_dir = "build",
      configure_args = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
    },
  },
}
