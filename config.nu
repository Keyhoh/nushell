# config.nu
#
# Installed by:
# version = "0.108.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# completions for nixos management command
def nixos-subCommands [] { ["update", "upgrade", "optimise", "clean"] }
# nixos management command
def nixos [subCommand:string@nixos-subCommands] {
    match $subCommand {
        "update" => { sudo nix flake update --flake ~/.config/nixos },
        "upgrade" => { sudo nixos-rebuild switch --flake ~/.config/nixos },
        "optimise" => { sudo nix store optimise },
        "clean" => { sudo nix-collect-garbage -d },
        _ => { echo "Usage: nixos [update|upgrade|optimise|clean]" }
    }
}

use ~/.config/nushell/share/nu_scripts/aliases/git/git-aliases.nu *
use ~/.config/nushell/share/nu_scripts/aliases/eza/eza-aliases.nu *

source $"($nu.cache-dir)/carapace.nu"

$env.config.show_banner = false

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

