#!/bin/bash

set -e

export VLOG_AMS=/eda/SolidoSimulationSuite/solidosim/solidosim/qforams/v2025.3_2/linux_x86_64/vlog
ADMS_INC=/eda/SolidoSimulationSuite/solidosim/solidosim/questasim/verilog_src/adms_vlams

echo "=== Compilando modelos analogicos ==="

valog -target_type wreal +incdir+$ADMS_INC dut/SampleHold.va
valog -target_type wreal +incdir+$ADMS_INC dut/Comparador.va
valog -target_type wreal +incdir+$ADMS_INC dut/DAC_Capacitivo.va
valog -target_type wreal +incdir+$ADMS_INC dut/IdealFlipFlop.va

echo "=== Compilando bloques SAR ==="

valog -target_type wreal +incdir+$ADMS_INC dut/SARSequenceRow.va
valog -target_type wreal +incdir+$ADMS_INC dut/SARCodeRow.va
valog -target_type wreal +incdir+$ADMS_INC dut/SARLogic.va
valog -target_type wreal +incdir+$ADMS_INC dut/SARR.va

echo "=== Compilando ADC top ==="

$VLOG_AMS dut/adc_top.v

echo "=== Compilando interfaz UVM ==="

$VLOG_AMS -sv tb/interfaces/adc_gp_interface.sv

echo "=== Compilando package UVM ==="

$VLOG_AMS -sv tb/adc_tb_pkg.sv

echo "=== Compilando tb_top ==="

$VLOG_AMS -sv tb/tb_top.sv

echo "=== Compilando test_fixture ==="

$VLOG_AMS -sv test_fixture.sv

echo "======================================"
echo " COMPILACION COMPLETADA CORRECTAMENTE "
echo "======================================"
