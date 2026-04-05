{
  yants,
  root,
  super,
}:
with (yants "popflow.haumea");
let
  inherit (super.structAttrs)
    haumeaLoadPop
    haumeaExporterPop
    haumeaInitLoadPop
    haumeaDefaultPop
    haumeaLoadExtender
    haumeaLoadExtenderPop
    pop
    ;
  inherit (haumeaInitLoadPop) initLoad;

  # Public named contracts that mirror the POP-first `haumea.pops.*` surface
  # and the richer load-extender vocabulary used by the module experiments.
  popType = openStruct pop;
  loadExtenderType = struct "haumea.loadExtender" haumeaLoadExtender;
  loadExtenderPopType = struct "haumea.loadExtenderPop" haumeaLoadExtenderPop;
  loadPopType = openStruct haumeaLoadPop;
  exporterPopType = openStruct haumeaExporterPop;
  defaultPopType = openStruct haumeaDefaultPop;
  initLoadPopType = openStruct haumeaInitLoadPop;
in
{
  pop = popType;

  # POP-first aliases that mirror the public `haumea.pops.*` teaching surface.
  loadExtender = loadExtenderType;
  loadExtenderPop = loadExtenderPopType;
  loadPop = loadPopType;
  exporterPop = exporterPopType;
  defaultPop = defaultPopType;
  initLoadPop = initLoadPopType;

  # Compatibility aliases for the older haumea-prefixed vocabulary.
  haumeaLoadExtender = loadExtenderType;
  haumeaLoadExtenderPop = loadExtenderPopType;
  haumeaLoadPop = loadPopType;
  haumeaExporterPop = exporterPopType;
  haumeaDefaultPop = defaultPopType;
  haumeaInitLoadPop = initLoadPopType;
  haumeaLoad = initLoad;
}
