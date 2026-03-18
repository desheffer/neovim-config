inputs:

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.programs.neovim-config.preview;

  nodeDep = pkgs'.stdenv.mkDerivation {
    pname = "markdown-preview-nvim-node-modules";
    version = "unstable";
    src = inputs.markdown-preview-nvim;
    nativeBuildInputs = with pkgs'; [
      yarnConfigHook
    ];
    yarnOfflineCache = pkgs'.fetchYarnDeps {
      yarnLock = "${inputs.markdown-preview-nvim}/yarn.lock";
      hash = "sha256-kzc9jm6d9PJ07yiWfIOwqxOTAAydTpaLXVK6sEWM8gg=";
    };
    installPhase = ''
      cp -r node_modules $out
    '';
  };

  markdown-preview-nvim = pkgs'.vimUtils.buildVimPlugin {
    name = "markdown-preview-nvim";
    src = inputs.markdown-preview-nvim;
    doCheck = false;

    nativeBuildInputs = with pkgs'; [ nodejs ];

    postPatch = ''
      substituteInPlace autoload/mkdp/rpc.vim \
        --replace-fail "elseif executable('node')" "else" \
        --replace-fail "'node'" "'${pkgs'.nodejs}/bin/node'"

      substituteInPlace autoload/health/mkdp.vim \
        --replace-fail "elseif executable('node')" "else" \
        --replace-fail "vim.fn.system('node --version')" "vim.fn.system('${pkgs'.nodejs}/bin/node --version')"
    '';

    postInstall = ''
      cp -r ${nodeDep} $out/app/node_modules
    '';
  };

in
{
  options.programs.neovim-config.preview = { };

  config.programs.neovim-config = {
    extraPackages = with pkgs'; [ nodejs ];

    plugins = [
      markdown-preview-nvim
    ];
  };
}
