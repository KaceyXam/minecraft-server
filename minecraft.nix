{ pkgs, lib, inputs, ... }: {
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  
  services.minecraft-servers =
  let
    modpack = pkgs.fetchModrinthModpack {
      src = ./modpacks/Modded-Kniffen-Fam-V2.mrpack;
      packHash = "sha256-D6watti/cap63iQNiW/Nn+sYiHNls28YXrI3AVH9yak=";
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
          crimsonware = "41f65275-983a-49c7-8051-2dcadc095c2b";
          maxtwoknight = "4f8aaadf-67d7-412b-951e-6fb7c9950819";
          gabrieltacoma = "875c5f65-dd31-4022-9abd-7b5601c42a36";
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
