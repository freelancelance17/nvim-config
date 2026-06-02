return {
  -- roslyn.nvim: wires up Microsoft's official Roslyn language server
  -- (Microsoft.CodeAnalysis.LanguageServer) — the same one VS Code's C# extension uses.
  -- Replaces csharp_ls (community fork) which is slower and missing newer features.
  --
  -- Roslyn requires solution/project detection + a non-standard LSP handshake;
  -- this plugin handles both so we don't have to roll a custom vim.lsp.config.
  --
  -- Install the server with `:MasonInstall roslyn` (the Crashdummyy mason registry
  -- already added in lsp.lua provides the package).
  {
    "seblyng/roslyn.nvim",
    ft = { "cs" },
    opts = {
      config = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),

        on_attach = function(client, bufnr)
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end,

        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true,
          },
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
            dotnet_provide_regex_completions = true,
          },
        },
      },
    },
  },
}
