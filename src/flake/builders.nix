{
  root,
  ...
}:
{
  inputsExtender = root.flake.pops.inputs;
  exporter = root.flake.pops.exporter;
  pipeline = root.flake.pops.default;
}
