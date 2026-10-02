# Contexto del proyecto TFG para Codex

## Objetivo general

Este repositorio corresponde a un TFG centrado en la **creación de un entorno de verificación UVM para un sistema mixed-signal**, más que en la complejidad del DUT en sí.

La idea es demostrar una infraestructura reutilizable y razonablemente completa:

- SystemVerilog + UVM para la parte de verificación.
- QuestaSim / Questa ADMS para simulación mixed-signal.
- Modelos analógicos / mixed-signal integrados mediante boundary elements.
- Ejecución en Rocky Linux.
- Trabajo remoto mediante VS Code + SSH.
- Gestión del repositorio con Git/GitHub.

El DUT final será un ADC jerárquico, pero actualmente se está verificando primero un bloque sencillo de **Sample & Hold** para validar la infraestructura.

---

## Estado actual

La infraestructura básica UVM ya funciona.

Elementos presentes o ya implementados:

- `transaction`
- `sequence / sequencer`
- `driver`
- `monitor`
- `agent`
- `environment`
- `test`
- `interface`
- `test_fixture`
- package UVM del ADC

La simulación UVM funciona correctamente y actualmente se dispone de un test:

```text
adc_sh_test
```

que verifica el bloque Sample & Hold.

La topología actual de simulación usa:

```text
work.test_fixture
```

como test fixture principal.

---

## Mixed-signal / Questa ADMS

La simulación del Sample & Hold se ejecuta con Questa ADMS usando `vasim`.

Comando actual:

```bash
vasim -c -cmd sim/ms_sample_hold.cmd work.test_fixture +UVM_TESTNAME=adc_sh_test -do "run -all; quit -f"
```

El fichero de configuración mixed-signal es:

```text
sim/ms_sample_hold.cmd
```

Contenido aproximado actual:

```spice
* Boundary elements REAL <-> electrical

.model a2d_real a2d mode=real
.model d2a_real d2a mode=real

.defhook a2d_real d2a_real

.probe tran v
```

Se utilizan boundary elements REAL <-> electrical mediante:

```text
A2D_REAL
D2A_REAL
```

Questa ADMS inserta automáticamente los converters.

La simulación genera una base de datos de ondas:

```text
sim/ms_sample_hold.wdb
```

que puede visualizarse con:

```bash
ezwave sim/ms_sample_hold.wdb &
```

o, si ya se está dentro de `sim/`:

```bash
ezwave ms_sample_hold.wdb &
```

La GUI de Solido Wave / EZwave ya funciona correctamente.

---

## Sample & Hold

El bloque Sample & Hold ya simula correctamente.

En una prueba reciente:

```text
SH vin = 0.730
SH vout = 0.730
```

y el test termina sin errores UVM.

Ejemplo de salida:

```text
UVM_INFO [DRV] SH vin = 0.730
UVM_INFO [MON] SH vin = 0.730 | SH vout = 0.730

UVM_ERROR : 0
UVM_FATAL : 0
```

Por tanto, la cadena:

```text
UVM -> interfaz -> mixed-signal DUT -> monitor
```

ya está operativa.

---

## Problema temporal actual del monitor

Actualmente el monitor contiene un pequeño retraso temporal introducido manualmente para leer correctamente la salida del Sample & Hold.

Conceptualmente es algo del estilo:

```systemverilog
@(posedge vif.clk);
#delay;
tr.vout = vif.vout;
```

Este retraso se introdujo para evitar leer la salida demasiado pronto.

Todavía hay que determinar si dicho retraso es:

1. una solución temporal a una **race condition de SystemVerilog**, o
2. un tiempo físicamente necesario para el **settling de la parte analógica**.

No eliminarlo sin comprobar primero cuál de los dos casos es.

---

# Próximos pasos

## 1. Añadir clocking blocks a la interfaz

Este es el siguiente cambio prioritario.

Objetivo:

- definir formalmente cuándo conduce señales el driver;
- definir formalmente cuándo observa señales el monitor;
- evitar races entre DUT, driver y monitor;
- eliminar delays manuales que solo existan por problemas de scheduling.

Revisar primero:

```text
tb/interfaces/adc_gp_interface.sv
```

y los modports existentes.

La interfaz debe seguir separando claramente:

- señales conducidas por el driver;
- señales observadas por el monitor;
- señales expuestas al DUT.

Añadir clocking blocks apropiados, por ejemplo conceptualmente:

```systemverilog
clocking driver_cb @(posedge clk);
    output ...;
    input ...;
endclocking

clocking monitor_cb @(posedge clk);
    input ...;
endclocking
```

No copiar esta plantilla literalmente sin revisar primero las señales reales de la interfaz.

Después modificar:

```text
tb/agent/adc_driver.sv
tb/agent/adc_monitor.sv
```

para acceder a las señales mediante dichos clocking blocks.

### Criterio importante

Si el retraso actual del monitor existe únicamente para evitar una race, sustituirlo por el clocking block.

Si representa settling analógico real, conservar ese concepto y convertirlo en un parámetro explícito/documentado.

---

## 2. Jerarquizar el DUT

Actualmente el entorno está demasiado acoplado al bloque Sample & Hold.

El objetivo es pasar progresivamente a una jerarquía similar a:

```text
ADC DUT
|
+-- Sample & Hold
+-- siguiente bloque
+-- ...
```

El testbench debe terminar viendo un DUT ADC, no una colección de bloques independientes conectados de forma ad hoc.

El Sample & Hold debe seguir pudiendo verificarse individualmente.

Mantener tests separados, por ejemplo:

```text
adc_sh_test
adc_<next_block>_test
adc_full_test
```

La intención es demostrar **reutilización del entorno UVM**.

Antes de modificar la jerarquía:

1. localizar cómo se instancia actualmente `SampleHold`;
2. localizar las conexiones en `test_fixture`;
3. identificar qué señales pertenecen al DUT completo;
4. proponer una jerarquía mínima que no rompa el test existente.

No hacer una refactorización masiva de golpe.

---

## 3. Añadir scoreboard

Una vez estabilizado clocking + jerarquía, añadir comparación automática.

Arquitectura deseada:

```text
sequence
   |
driver
   |
 DUT
   |
monitor
   |
scoreboard
```

Para el Sample & Hold, el modelo esperado puede ser sencillo:

```text
cuando se produce el sample:
    expected_vout = vin_muestreado
```

La comparación debe considerar tolerancia:

```text
abs(vout - expected_vout) <= tolerance
```

No usar igualdad exacta para señales `real`.

La tolerancia debe estar definida como parámetro/configuración, no como magic number disperso.

---

## 4. Mejorar los tests del Sample & Hold

Después del scoreboard:

- probar varios valores de `vin`;
- probar extremos de rango;
- probar valores intermedios;
- probar múltiples operaciones consecutivas;
- comprobar hold;
- comprobar sample;
- comprobar que `vout` permanece estable cuando no se samplea.

La intención no es hacer una campaña exhaustiva de verificación del circuito, sino demostrar que el entorno UVM permite escalar la verificación.

---

# Filosofía del TFG

La prioridad no es construir el ADC más sofisticado posible.

La prioridad es demostrar:

```text
infraestructura
+ metodología UVM
+ integración mixed-signal
+ reutilización
+ automatización de checks
```

Por ello, evitar introducir complejidad innecesaria que no aporte valor al entorno de verificación.

---

# Forma de trabajar recomendada para Codex

Antes de modificar código:

1. inspeccionar la estructura del repositorio;
2. identificar archivos directamente implicados;
3. explicar brevemente qué se va a cambiar;
4. realizar cambios pequeños;
5. mantener compatibilidad con el test que ya funciona;
6. indicar qué hay que recompilar;
7. indicar el comando exacto de simulación para validar el cambio.

No modificar múltiples subsistemas a la vez salvo que sea imprescindible.

Priorizar cambios incrementales que puedan comprobarse inmediatamente.

---

# Comandos relevantes

Simulación actual del Sample & Hold:

```bash
vasim -c -cmd sim/ms_sample_hold.cmd work.test_fixture +UVM_TESTNAME=adc_sh_test -do "run -all; quit -f"
```

Abrir waveforms desde la raíz del proyecto:

```bash
ezwave sim/ms_sample_hold.wdb &
```

Buscar el WDB:

```bash
find /home/jalberic/proyectos/TFG -name "*.wdb" -type f
```

Repositorio esperado:

```text
/home/jalberic/proyectos/TFG
```

---

# Checklist inmediata

- [x] Infraestructura UVM básica funcionando
- [x] Driver
- [x] Monitor
- [x] Sequencer
- [x] Agent
- [x] Test
- [x] Sample & Hold mixed-signal funcionando
- [x] Boundary elements funcionando
- [x] Generación de `.wdb`
- [x] Visualización en EZwave / Solido Wave
- [ ] Revisar delay temporal actual del monitor
- [ ] Añadir clocking block(s)
- [ ] Adaptar driver al clocking block
- [ ] Adaptar monitor al clocking block
- [ ] Confirmar si el delay del monitor era race o settling real
- [ ] Jerarquizar DUT
- [ ] Mantener test individual del Sample & Hold
- [ ] Añadir scoreboard
- [ ] Añadir tolerancia analógica configurable
- [ ] Añadir más estímulos al Sample & Hold
- [ ] Integrar progresivamente el ADC completo

---

## Primera tarea recomendada para Codex

Inspeccionar:

```text
tb/interfaces/adc_gp_interface.sv
tb/agent/adc_driver.sv
tb/agent/adc_monitor.sv
```

y responder primero, sin modificar todavía código:

1. dónde existe riesgo de race;
2. por qué existe actualmente el retraso del monitor;
3. cómo introducir clocking blocks con el menor cambio posible;
4. qué líneas concretas habría que modificar;
5. cómo validar después el cambio con `adc_sh_test`.

Una vez revisado esto, implementar el clocking block de forma incremental.
