# Instalación y validación de QuestaSim + Solido Simulation Suite en WSL2 con Rocky Linux 8.10

## 1. Objetivo

Preparar en Windows 11 un entorno Linux mediante WSL2 con Rocky Linux 8.10 para ejecutar:

- QuestaSim.
- Solido Simulation Suite.
- Questa ADMS.
- Symphony.
- AFS.
- Simulación digital con SystemVerilog/UVM.
- Simulación analógica con Verilog-A.
- Licenciamiento de Siemens mediante un servidor accesible por VPN.

La estructura final utilizada fue:

```text
Windows 11
└── WSL2
    └── Rocky Linux 8.10
        ├── Usuario: jalberic
        ├── /eda/SolidoSimulationSuite/
        ├── Solido Simulation Suite
        ├── QuestaSim
        ├── AFS / Symphony / Questa ADMS
        └── ~/.bashrc
```

## 2. Instalación de WSL2

Desde PowerShell como administrador:

```powershell
wsl --install --no-distribution
wsl --update
wsl --set-default-version 2
wsl --status
```

Se verificó que WSL2 quedaba configurado como versión predeterminada.

## 3. Descarga e importación de Rocky Linux 8.10

Se descargó:

```text
Rocky-8-Container-Base-8.10-20240528.0.x86_64.tar.xz
```

Desde PowerShell:

```powershell
mkdir C:\WSL\Rocky810
wsl --import Rocky-8.10 C:\WSL\Rocky810 "$env:USERPROFILE\Downloads\Rocky-8-Container-Base-8.10-20240528.0.x86_64.tar.xz" --version 2
wsl -l -v
```

Se comprobó que `Rocky-8.10` aparecía con `VERSION 2`.

Entrada en Rocky:

```powershell
wsl -d Rocky-8.10
```

Comprobación:

```bash
cat /etc/rocky-release
```

Resultado:

```text
Rocky Linux release 8.10 (Green Obsidian)
```

## 4. Creación del usuario Linux

Inicialmente Rocky arrancaba como `root`.

```bash
dnf install -y sudo passwd
useradd -m -G wheel jalberic
passwd jalberic
printf "[user]\ndefault=jalberic\n" > /etc/wsl.conf
exit
```

Después, en PowerShell:

```powershell
wsl --terminate Rocky-8.10
wsl -d Rocky-8.10
```

Comprobación:

```bash
whoami
```

Resultado:

```text
jalberic
```

## 5. Actualización y utilidades básicas

```bash
sudo dnf update -y
sudo dnf install -y tar gzip xz unzip wget curl which file
sudo dnf install -y procps-ng findutils
```

## 6. Preparación de la ruta de instalación

El `.bashrc` proporcionado esperaba inicialmente:

```bash
export MGC_AMS_HOME=/eda/SolidoSimulationSuite/solidosim/
```

Se creó la estructura:

```bash
sudo mkdir -p /eda/SolidoSimulationSuite
sudo chown -R jalberic:jalberic /eda
```

## 7. Configuración del `.bashrc`

Archivo recibido en Windows:

```text
C:\Users\adame\Desktop\Coses JJ\ATT95818.bashrc
```

Se hizo copia del `.bashrc` original:

```bash
cp $HOME/.bashrc $HOME/.bashrc.backup
```

Se copió el archivo recibido:

```bash
cp "/mnt/c/Users/adame/Desktop/Coses JJ/ATT95818.bashrc" $HOME/.bashrc
```

Se validó:

```bash
bash -n $HOME/.bashrc
```

El archivo configura rutas de Questa/Solido, `PATH`, `LD_LIBRARY_PATH` y variables de licencia.

## 8. Licencia mediante VPN

El `.bashrc` apunta al servidor:

```text
29000@158.42.1.112
```

Se comprobó el acceso desde WSL2:

```bash
timeout 5 bash -c '</dev/tcp/158.42.1.112/29000' && echo OK || echo FALLO
```

Resultado:

```text
OK
```

Si la VPN se conecta después de iniciar WSL:

```powershell
wsl --shutdown
wsl -d Rocky-8.10
```

## 9. Instalador de Solido Simulation Suite

Instalador recibido:

```text
SolidoSimulationSuite_2026_1_1.aol.installer.bin
```

Ubicación:

```text
C:\Users\adame\Downloads\SolidoSimulationSuite_2026_1_1.aol.installer.bin
```

Comprobación:

```bash
file "/mnt/c/Users/adame/Downloads/SolidoSimulationSuite_2026_1_1.aol.installer.bin"
```

Se confirmó que era un ejecutable Linux x86-64.

Se copió a Rocky:

```bash
cp "/mnt/c/Users/adame/Downloads/SolidoSimulationSuite_2026_1_1.aol.installer.bin" $HOME/
chmod +x $HOME/SolidoSimulationSuite_2026_1_1.aol.installer.bin
```

## 10. Dependencias gráficas del instalador Siemens

Faltaron varias bibliotecas X11:

```bash
sudo dnf install -y libXext
sudo dnf install -y libXrender libXtst libXi
```

Java también necesitó fuentes:

```bash
sudo dnf install -y fontconfig dejavu-sans-fonts dejavu-serif-fonts
fc-cache -fv
```

Se verificó WSLg:

```bash
echo $DISPLAY
echo $WAYLAND_DISPLAY
```

Resultados:

```text
:0
wayland-0
```

## 11. Instalación desde Siemens Install

Se lanzó:

```bash
$HOME/SolidoSimulationSuite_2026_1_1.aol.installer.bin
```

En el instalador se eligió:

```text
Install from the Cloud
```

Ruta de destino:

```text
/eda/SolidoSimulationSuite/solidosim
```

Para UVM + Verilog-A se seleccionaron:

1. AFS / AFS Mega / Solido SPICE / Solido FastSPICE / Solido LibSPICE.
2. Symphony.
3. Questa ADMS.

No se seleccionó Eldo.

## 12. Corrección de la ruta real instalada

La instalación creó:

```text
/eda/SolidoSimulationSuite/solidosim/solidosim/
```

Por tanto se corrigió:

```bash
sed -i 's|^export MGC_AMS_HOME=.*|export MGC_AMS_HOME=/eda/SolidoSimulationSuite/solidosim/solidosim/|' $HOME/.bashrc
```

Se añadió Questa al `PATH`:

```bash
echo 'export PATH="$QUESTASIM_HOME/linux_x86_64:$PATH"' >> $HOME/.bashrc
source $HOME/.bashrc
```

Comprobación:

```bash
command -v vsim
```

Resultado:

```text
/eda/SolidoSimulationSuite/solidosim/solidosim//questasim/linux_x86_64/vsim
```

El doble `//` no afecta.

## 13. Dependencia gráfica de QuestaSim

Al arrancar `vsim` faltó:

```text
libXft.so.2
```

Se solucionó:

```bash
sudo dnf install -y libXft
```

## 14. Prueba digital con SystemVerilog

Se creó:

```bash
mkdir -p $HOME/prueba_questa
cd $HOME/prueba_questa
```

### `sumador.sv`

```systemverilog
module sumador(
    input  logic [3:0] a, b,
    output logic [4:0] resultado
);
    assign resultado = a + b;
endmodule
```

### `tb.sv`

```systemverilog
module tb;
    logic [3:0] a, b;
    logic [4:0] resultado;

    sumador dut(.*);

    initial begin
        a = 3;
        b = 5;
        #10;

        if (resultado == 8)
            $display("SIMULACION CORRECTA: resultado=%0d", resultado);
        else
            $error("RESULTADO INCORRECTO");

        $finish;
    end
endmodule
```

Compilación y simulación:

```bash
vlib work
vlog -sv sumador.sv tb.sv
vsim -c work.tb -do "run -all; quit"
```

Resultado:

```text
SIMULACION CORRECTA: resultado=8
Errors: 0, Warnings: 0
```

Esto validó QuestaSim, SystemVerilog, la licencia y el `PATH`.

## 15. Prueba Verilog-A con AFS

Se localizaron ejemplos:

```bash
find "$MGC_AMS_HOME" -type f \( -iname "*.va" -o -iname "*.vams" \) 2>/dev/null | head -20
```

Se eligió:

```text
examples/afs/systest/resistor.vams
```

Se creó:

```bash
mkdir -p $HOME/prueba_veriloga
```

Se copiaron `resistor.vams` y `netlist_va.scs`, y se ejecutó:

```bash
cd $HOME/prueba_veriloga
afs netlist_va.scs
```

## 16. Dependencias para Verilog-A

Primero faltó:

```text
libgomp.so.1
```

Se instaló:

```bash
sudo dnf install -y libgomp
```

Después faltó `stdio.h` al compilar el código C generado por Verilog-A.

Se solucionó:

```bash
sudo dnf install -y gcc make glibc-devel glibc-headers
```

Comprobación:

```bash
ls /usr/include/stdio.h
```

Se repitió:

```bash
afs netlist_va.scs
```

Resultado final:

```text
Transient Analysis finished successfully.

******** SIMULATION finished with 0 error(s) and 0 warning(s) ********
```

Esto validó AFS, Verilog-A, el compilador C y el acceso a licencia.

## 17. Estado final

El entorno quedó:

```text
Windows 11
└── WSL2
    └── Rocky Linux 8.10
        ├── Usuario: jalberic
        ├── Solido Simulation Suite 2026.1 update1
        ├── QuestaSim 2026.1_1
        ├── Questa ADMS
        ├── Symphony
        ├── AFS
        ├── SystemVerilog: OK
        ├── Verilog-A: OK
        └── Licencia mediante VPN: OK
```

Comprobaciones útiles:

```bash
whoami
cat /etc/rocky-release
echo $MGC_AMS_HOME
echo $QUESTASIM_HOME
command -v vsim
command -v afs
```

Licencia:

```bash
timeout 5 bash -c '</dev/tcp/158.42.1.112/29000' && echo OK || echo FALLO
```

Prueba digital:

```bash
vlib work
vlog -sv sumador.sv tb.sv
vsim -c work.tb -do "run -all; quit"
```

Prueba analógica:

```bash
afs netlist_va.scs
```

## 18. Comandos útiles

Entrar en Rocky:

```powershell
wsl -d Rocky-8.10
```

Salir:

```bash
exit
```

Ver distribuciones WSL:

```powershell
wsl -l -v
```

Reiniciar WSL:

```powershell
wsl --shutdown
```

Recargar el entorno:

```bash
source $HOME/.bashrc
```

Arrancar Questa:

```bash
vsim
```

## 19. Nota importante sobre la ruta

La ruta efectiva final quedó:

```text
/eda/SolidoSimulationSuite/solidosim/solidosim/
```

Por eso el `.bashrc` tuvo que adaptarse a esa ubicación real.
