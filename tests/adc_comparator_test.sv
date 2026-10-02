// Integration test for the clocked comparator.  It deliberately uses two
// rising edges after a new Vin value: the first updates SampleHold and the
// second lets the comparator consume the already-held value.  See
// dut/COMPARATOR_TIMING.md for the shared-clock timing rationale.
class adc_comparator_test extends adc_base_test;

    `uvm_component_utils(adc_comparator_test)

    localparam time AMS_SETTLING_TIME = 200ps;
    localparam real CMP_TOLERANCE = 0.05;

    function new(string name = "adc_comparator_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task automatic drive_before_next_sample(real vin, real cmp_ref);
        @(negedge env.agent.driver.vif.clk);
        env.agent.driver.vif.vin     = vin;
        env.agent.driver.vif.cmp_ref = cmp_ref;
    endtask

    task automatic check_cmp(string case_name, real expected);
        real actual;

        #(AMS_SETTLING_TIME);
        actual = env.agent.driver.vif.cmp_out;
        if ((actual < (expected - CMP_TOLERANCE)) ||
            (actual > (expected + CMP_TOLERANCE))) begin
            `uvm_error("CMP_TEST",
                $sformatf("%s: cmp_out=%0.3f V, expected %0.1f V",
                          case_name, actual, expected))
        end
        else begin
            `uvm_info("CMP_TEST",
                $sformatf("%s: cmp_out=%0.3f V", case_name, actual),
                UVM_LOW)
        end
    endtask

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        // Avoid the time-zero initialization race before waiting for the
        // first complete low phase of the generated clock.
        #1ps;

        // Case 1: a held SampleHold voltage greater than cmp_ref produces 1 V.
        drive_before_next_sample(1.2, 0.5);
        @(posedge env.agent.driver.vif.clk); // SampleHold captures 1.2 V.
        @(posedge env.agent.driver.vif.clk); // Comparator consumes held 1.2 V.
        check_cmp("CASE 1: InS > InD", 1.0);

        // Case 2: a held SampleHold voltage less than cmp_ref produces 0 V.
        drive_before_next_sample(0.3, 0.5);
        @(posedge env.agent.driver.vif.clk); // SampleHold captures 0.3 V.
        @(posedge env.agent.driver.vif.clk); // Comparator consumes held 0.3 V.
        check_cmp("CASE 2: InS < InD", 0.0);

        // Case 3: neither Vin nor cmp_ref may affect cmp_out between clock
        // crossings.  At the next crossing the comparator still uses the old
        // held SampleHold voltage; the following one sees the newly held value.
        @(negedge env.agent.driver.vif.clk);
        #2ns;
        env.agent.driver.vif.vin     = 1.2;
        env.agent.driver.vif.cmp_ref = 0.4;
        check_cmp("CASE 3: unchanged between clock edges", 0.0);
        @(posedge env.agent.driver.vif.clk);
        check_cmp("CASE 3: old held value at next edge", 0.0);
        @(posedge env.agent.driver.vif.clk);
        check_cmp("CASE 3: new held value at following edge", 1.0);

        // Case 4: equality follows the model's else branch and produces 0 V.
        drive_before_next_sample(0.75, 0.75);
        @(posedge env.agent.driver.vif.clk); // SampleHold captures 0.75 V.
        @(posedge env.agent.driver.vif.clk); // Comparator sees equality.
        check_cmp("CASE 4: InS == InD", 0.0);

        phase.drop_objection(this);
    endtask

endclass
