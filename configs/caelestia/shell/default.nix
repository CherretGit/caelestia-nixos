{
  config,
  lib,
  pkgs,
  mod,
  ...
}:
let
  jsonFormat = pkgs.formats.json {};
  jsonConfig = jsonFormat.generate "caelestia-shell.json" mod;
in
{
  config = {
    programs.caelestia.settings = mod;
    xdg.configFile."caelestia/shell.json".enable = lib.mkForce false;
    home.activation.caelestiaMutableConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $HOME/.config/caelestia
      if [ ! -f $HOME/.config/caelestia/shell.json ]; then
        cp ${jsonConfig} $HOME/.config/caelestia/shell.json
        chmod 644 $HOME/.config/caelestia/shell.json
      fi
    '';
  };
}
