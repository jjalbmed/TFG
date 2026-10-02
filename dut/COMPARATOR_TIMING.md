# Comparator timing with the current shared clock

`SampleHold` and `Comparador` are both sensitive to the same rising crossing
of the electrical `clk`.  On that crossing, each Verilog-A event evaluates
from the values that existed immediately before the event.  `SampleHold`
updates `sh_vout` through its 1 ps transition only after it has captured
`vin`; therefore the comparator cannot reliably use that newly sampled value
on the same crossing.  It decides from the previously held `sh_vout` value.

The integration test deliberately reflects this one-edge behavior: it first
samples a value and verifies the comparator decision on the following rising
edge.  No delay, bridge, or clocking-block workaround has been added.

For SAR conversion, the minimal coherent architectural change is to expose a
separate comparator/conversion clock after the sampling phase (for example,
`sample_clk` for `SampleHold` and `cmp_clk` for `Comparador`).  The SAR control
logic can then place `cmp_clk` after the SampleHold settling interval.  That
change is intentionally deferred until those control signals are introduced.

When the DAC is later connected to `Comparador.InD`, SAR control must set the
DAC code and allow the mixed-signal DAC path to settle before the comparator
clock crossing that takes the decision.
