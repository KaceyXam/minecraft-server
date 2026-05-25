{ pkgs, lib, inputs, ... }: {
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  
  services.minecraft-servers =
  let
    modpack = pkgs.fetchModrinthModpack {
      src = ./modpacks/Modded-Kniffen-Fam.mrpack;
      packHash = "sha256-P3Bd/i2JLegHbVjdpPBSMiG27uHdZ/5FSg58zVFIA8g=";
    };
  in {
    enable = true;
    eula = true;
    openFirewall = true;

    servers = {
      modded = {
        enable = true;
        package = pkgs.neoforgeServers.neoforge-1_21_1;

        serverProperties = {
          server-port = 25565;
          allow-flight = true;
          difficulty = "normal";
          motd = "Kniffen Fam Modded Minecraft Server";
        };

        symlinks = {
          "mods" = "${modpack}/mods";
        };

        operators = {
          KaceyXamComics = "98026ffc-e6de-4ad1-914d-26fcdfbf1a88";
        };
      };

      vanilla = {
        enable = true;
        package = pkgs.paperServers.paper-1_21_11;
        autoStart = false;

        serverProperties = {
          server-port = 25566;
          difficulty = "normal";
        };

        operators = {
          KaceyXamComics = "98026ffc-e6de-4ad1-914d-26fcdfbf1a88";
        };
      };
    };
  };
}
