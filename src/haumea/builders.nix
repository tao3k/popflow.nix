{ root, ... }:
{
  loadExtender = root.haumea.pops.load;
  exporter = root.haumea.pops.exporter;
  pipeline = root.haumea.pops.default;
}
