{ self }:

final: prev: {
  microca = self.packages.${prev.stdenv.hostPlatform.system}.microca;
}
