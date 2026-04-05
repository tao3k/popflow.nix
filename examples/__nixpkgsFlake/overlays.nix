inputs:
let
  inherit (inputs.POP) kxPop extendPop;
in
pkgs: _: {
  helloPop = extendPop pkgs.hello (
    hello: super: {
      propagatedBuildInputs = super.propagatedBuildInputs ++ [ pkgs.curl ];

      attrs = extendPop super.drvAttrs (
        _: superAttrs: {
          src = kxPop superAttrs.src { propagatedBuildInputs = [ pkgs.wget ]; };
        }
      );
    }
  );
}
