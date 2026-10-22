{ pkgs, lib, inputs, ... }: {
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  
  services.minecraft-servers =
  let
    modpack = pkgs.fetchModrinthModpack {
      src = ./modpacks/Modded-Kniffen-Fam-V2.mrpack;
      packHash = "sha256-ngg0VCSf1ERGLF6Y+ApNvK0s/yGAOOn9nfSmyh536z4=";
    };
    modpack_v2 = pkgs.fetchModrinthModpack {
      src = ./modpacks/2_Modded_2_Kniffen.mrpack;
      packHash = "sha256-kld/+8UjGEvPunGcrv/dMjk7+CLtC3Q1q3ZKIr6RRiY=";
    };

    modpack_v2_mods = pkgs.runCommand "modpack-v2-mods" {} ''
      cp -rL --no-preserve=mode ${modpack_v2}/mods $out

      rm $out/create-1.21.1-*.jar

      cp ${./modpacks/patches/create-1.21.1-6.0.10.jar} $out
    '';
  in {
    enable = true;
    eula = true;
    openFirewall = true;
    managementSystem.systemd-socket.enable = true;

    servers = {
      modded = {
        enable = true;
        package = pkgs.neoforgeServers.neoforge-1_21_1;
        autoStart = false;

        serverProperties = {
          server-port = 25566;
          allow-flight = true;
          difficulty = "normal";
          motd = "Kniffen Fam Modded Minecraft Server";
          view-distance = 6;
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

      modded_2 = {
        enable = true;
        package = pkgs.neoforgeServers.neoforge-1_21_1;

        jvmOpts = "-Xms4G -Xmx24G";

        serverProperties = {
          server-port = 25565;
          allow-flight = true;
          difficulty = "normal";
          motd = "Kniffen Fam Modded Minecraft Server";
          view-distance = 8;
        };

        symlinks = {
          "mods" = modpack_v2_mods;
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
          server-port = 25567;
          difficulty = "normal";
        };

        operators = {
          KaceyXamComics = "98026ffc-e6de-4ad1-914d-26fcdfbf1a88";
        };
      };
    };
  };
}
