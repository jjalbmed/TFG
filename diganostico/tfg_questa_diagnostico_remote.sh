set +e

section() {
    echo
    echo "============================================================"
    echo "$1"
    echo "============================================================"
}

section "1. SISTEMA Y DIRECTORIO"
date
hostname
whoami
uname -a
echo "PWD inicial: $(pwd)"
cd "$PROJECT" || { echo "ERROR: no se puede entrar en $PROJECT"; exit 1; }
echo "PWD proyecto: $(pwd)"

section "2. VARIABLES DE ENTORNO RELEVANTES"
echo "PATH=$PATH"
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
env | grep -Ei '^(MGC|MENTOR|QUESTA|MODELSIM|SOLIDO|ELDO|AOL|QFORAMS|LM_LICENSE|SALT|PATH|LD_LIBRARY_PATH)=' | sort

section "3. EJECUTABLES EN USO"
for c in vlog vlib vsim vasim valog vams ezwave; do
    echo
    echo "---- $c ----"
    command -v "$c" 2>/dev/null || true
    type -a "$c" 2>/dev/null || true
done

section "4. VERSIONES"
echo "--- vlog -version ---"
vlog -version 2>&1 || true
echo
echo "--- vsim -version ---"
vsim -version 2>&1 || true
echo
echo "--- vasim -version ---"
vasim -version 2>&1 || true

section "5. QFORAMS 2025.3_2"
QF="/eda/SolidoSimulationSuite/solidosim/solidosim/qforams/v2025.3_2"
echo "QFORAMS=$QF"
if [ -d "$QF" ]; then
    find "$QF" -maxdepth 3 \( -name vlog -o -name vlib -o -name vsim -o -name valog -o -name "valog*" \) -ls 2>/dev/null
    echo
    echo "--- version del vlog QFORAMS ---"
    "$QF/linux_x86_64/vlog" -version 2>&1 || true
else
    echo "No existe $QF"
fi

section "6. HERRAMIENTAS ANALOGICAS / VALOG"
SOL="/eda/SolidoSimulationSuite/solidosim/solidosim"
find "$SOL" -name "valog*" -ls 2>/dev/null
echo
echo "--- localizacion liberrm_64.so ---"
find "$SOL" -name "liberrm_64.so" -ls 2>/dev/null
echo
echo "--- valog_64: file / ldd ---"
if [ -e "$SOL/aol/bin/valog_64" ]; then
    file "$SOL/aol/bin/valog_64" 2>&1 || true
    ldd "$SOL/aol/bin/valog_64" 2>&1 || true
fi

section "7. VASIM: RESOLUCION Y WRAPPERS"
VASIM_PATH="$(command -v vasim 2>/dev/null)"
echo "vasim command: $VASIM_PATH"
if [ -n "$VASIM_PATH" ]; then
    ls -l "$VASIM_PATH" 2>&1 || true
    readlink -f "$VASIM_PATH" 2>&1 || true
    file "$VASIM_PATH" 2>&1 || true
fi
echo
echo "--- candidatos vasim ---"
find "$SOL" -maxdepth 4 -name "vasim*" -ls 2>/dev/null | head -100

section "8. MODELSIM.INI / LIBRERIAS"
if [ -f modelsim.ini ]; then
    echo "--- modelsim.ini ---"
    sed -n '1,240p' modelsim.ini
else
    echo "No hay modelsim.ini en la raiz."
fi
echo
echo "--- contenido de work ---"
find work -maxdepth 2 -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %p\n' 2>/dev/null | sort | head -200

section "9. ESTRUCTURA DEL REPOSITORIO"
find . -maxdepth 4 -type f \( \
    -name "*.sv" -o -name "*.v" -o -name "*.va" -o -name "*.vams" -o \
    -name "*.cmd" -o -name "*.f" -o -name "*.do" \
\) | sort

section "10. REFERENCIAS A SAMPLEHOLD / ADC_TOP"
grep -RniE --include='*.sv' --include='*.v' --include='*.va' --include='*.vams' --include='*.cmd' \
    'SampleHold|adc_top|sample_hold|defhook|a2d_real|d2a_real' \
    dut tb sim test_fixture.sv tests 2>/dev/null || true

section "11. FUENTES ANALOGICAS COMPLETAS"
find dut tb sim -type f \( -name '*.va' -o -name '*.vams' \) 2>/dev/null | sort | while read -r f; do
    echo
    echo "---------------- FILE: $f ----------------"
    sed -n '1,260p' "$f"
done

section "12. ARCHIVOS CLAVE"
for f in \
    dut/adc_top.va \
    dut/adc_top.v \
    test_fixture.sv \
    sim/ms_sample_hold_top.v \
    sim/ms_sample_hold.cmd \
    tb/interfaces/adc_gp_interface.sv \
    tb/agent/adc_driver.sv \
    tb/agent/adc_monitor.sv \
    tb/transactions/adc_transaction.sv \
    tb/sequences/sh_sequence.sv \
    tb/adc_tb_pkg.sv
do
    if [ -f "$f" ]; then
        echo
        echo "---------------- FILE: $f ----------------"
        sed -n '1,320p' "$f"
    fi
done

section "13. TRANSCRIPTS: COMO SE CARGABA SAMPLEHOLD"
for f in transcript transcript_ms vasim.errm.log sim/*.errm.log; do
    [ -f "$f" ] || continue
    echo
    echo "---------------- LOG: $f ----------------"
    grep -nEi 'SampleHold|valog|vlog|vasim|Loading|Converter|A2D|D2A|defhook|Verilog.?A|electrical|wreal' "$f" 2>/dev/null | tail -250
done

section "14. ARCHIVOS GENERADOS POR ADMS"
find sim . -maxdepth 2 -type f \( \
    -name "*.chi" -o -name "*.conv" -o -name "*.id" -o -name "*.wdb" -o \
    -name "*.errm.log" \
\) -printf '%TY-%Tm-%Td %TH:%TM:%TS %10s %p\n' 2>/dev/null | sort -u

section "15. CONVERTERS INSERTADOS"
for f in sim/*.conv *.conv; do
    [ -f "$f" ] || continue
    echo
    echo "---------------- FILE: $f ----------------"
    sed -n '1,260p' "$f"
done

section "16. BUSQUEDA DE SAMPLEHOLD"
echo "--- fuentes del proyecto ---"
find "$PROJECT" -type f \( -iname '*sample*hold*' -o -iname '*samplehold*' \) -ls 2>/dev/null
echo
echo "--- definicion del modulo SampleHold ---"
find dut tb sim -type f \( -name '*.va' -o -name '*.vams' -o -name '*.v' -o -name '*.sv' \) \
    -exec grep -Il 'module[[:space:]]\+SampleHold' {} \; 2>/dev/null

section "17. HISTORIAL RECIENTE RELEVANTE"
if [ -f "$HOME/.bash_history" ]; then
    grep -Ei 'vlog|valog|vasim|vsim|SampleHold|sample_hold|adc_top' "$HOME/.bash_history" | tail -200
else
    echo "No se puede leer ~/.bash_history"
fi

section "18. RESUMEN RAPIDO"
echo "vlog actual: $(command -v vlog 2>/dev/null)"
echo "vasim actual: $(command -v vasim 2>/dev/null)"
echo "adc_top.va existe: $([ -f dut/adc_top.va ] && echo SI || echo NO)"
echo "adc_top.v existe:  $([ -f dut/adc_top.v ] && echo SI || echo NO)"
echo
echo "FIN DEL DIAGNOSTICO"
