/*
  Assemble a curated example surface for POP learning and the three main popflow
  domains. The public examples are explicit on purpose so the learning path is
  stable and does not depend on whatever files happen to exist in this
  directory.

  Type: { inputs = AttrSet; lib = AttrSet; } -> AttrSet
*/
{ lib, inputs }:
{
  pop = import ./pop-vocabulary.nix { inherit inputs; };
  yants = import ./yants-contracts.nix { inherit inputs lib; };
  configs = import ./configs-workflow.nix { inherit inputs lib; };
  flake = import ./flake-workflow.nix { inherit inputs lib; };
  haumea = {
    data = import ./haumea-data-workflow.nix { inherit inputs lib; };
    modules = import ./haumea-module-experiment.nix { inherit inputs lib; };
  };
}
