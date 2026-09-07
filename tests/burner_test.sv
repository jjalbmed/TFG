`include "uvm_macros.svh"
import uvm_pkg::*;

class burner extends uvm_test; //class define
    `uvm_component_utils(burner)

//constructor

    function new(string name = "burner", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    task run_phase (uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("BURNER","UVM works all right", UVM_LOW)
        phase.drop_objection(this);
    endtask        


endclass

module tb_top;

    initial begin
        run_test("burner");

    end

endmodule