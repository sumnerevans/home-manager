{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ../../accounts/email-test-accounts.nix ];

  config = {
    accounts.email.accounts = {
      "hm@example.com".neomutt = { enable = true; sortOrder = 0; };
      hm-account.neomutt = { enable = true; sortOrder = 1; };
    };

    programs.neomutt.enable = true;

    nixpkgs.overlays =
      [ (self: super: { neomutt = pkgs.writeScriptBin "dummy-neomutt" ""; }) ];

    nmt.script = ''
      assertFileExists home-files/.config/neomutt/neomuttrc
      assertFileContent home-files/.config/neomutt/neomuttrc ${
        ./neomutt-sort-order-expected.conf
      }
    '';
  };
}
