{ self }:

final: prev: {
  microca = self.packages.${prev.system}.microca;
}
