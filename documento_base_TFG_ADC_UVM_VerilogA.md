# Documento base del TFG — Verificación UVM de un ADC modelado en Verilog-A

## 1. Objetivo general

El objetivo del TFG es desarrollar una metodología de verificación para un ADC descrito en Verilog-A utilizando UVM como framework de verificación y las herramientas de simulación de Siemens EDA instaladas en un entorno Rocky Linux 8.10 sobre WSL2.

La idea principal es combinar:

- Un **modelo analógico del ADC en Verilog-A**.
- Un **entorno de verificación en SystemVerilog/UVM**.
- Un **simulador mixed-signal** capaz de integrar ambos dominios.
- Un **modelo de referencia** que permita decidir automáticamente si cada conversión del ADC es correcta.
- Una estrategia de **tests, regresión y cobertura** que permita evaluar la calidad de la verificación.

---

## 2. Objetivos específicos

1. Comprender el funcionamiento del ADC que se desea verificar.
2. Comprender y validar de forma independiente el modelo Verilog-A.
3. Diseñar un entorno UVM adecuado para estimular y monitorizar el ADC.
4. Integrar el dominio digital de UVM con el dominio analógico del ADC.
5. Implementar un modelo de referencia del ADC.
6. Implementar un scoreboard automático.
7. Crear tests dirigidos y aleatorios.
8. Medir cobertura funcional.
9. Automatizar simulaciones y regresiones.
10. Analizar los resultados y documentar las limitaciones de la metodología.

---

## 3. Alcance previsto

El trabajo debe permitir verificar, como mínimo:

- Correcta conversión de tensión analógica a código digital.
- Comportamiento en los extremos del rango.
- Saturación inferior y superior.
- Transiciones entre códigos.
- Barrido del rango completo.
- Casos aleatorios.
- Comparación automática frente a un modelo ideal.

Dependiendo del tiempo disponible y del modelo del ADC, también se podrán verificar:

- Offset.
- Gain error.
- DNL.
- INL.
- Missing codes.
- Monotonicidad.
- Tiempo de conversión.
- Frecuencia de muestreo.

Como extensión opcional:

- SNR.
- SINAD.
- ENOB.
- THD.

---

## 4. Arquitectura conceptual

La arquitectura prevista es:

```text
UVM Test
   ↓
UVM Sequence
   ↓
Sequencer
   ↓
Driver
   ↓
Interfaz mixed-signal
   ↓
ADC Verilog-A
   ↓
Monitor
   ↓
Scoreboard
   ↓
Modelo de referencia
   ↓
PASS / FAIL / cobertura
```

El entorno debe separar claramente:

- Generación de estímulos.
- Aplicación de estímulos al DUT.
- Observación de resultados.
- Cálculo del resultado esperado.
- Comparación.
- Cobertura.

---

## 5. Tecnologías principales

### Lenguajes

- SystemVerilog.
- UVM.
- Verilog-A.
- Tcl / scripts de simulación.
- Bash.
- Posiblemente Makefile o scripts equivalentes.

### Herramientas

- Windows 11.
- WSL2.
- Rocky Linux 8.10.
- Solido Simulation Suite.
- QuestaSim.
- Questa ADMS.
- Symphony.
- AFS.
- Git / GitHub.

---

## 6. Estado actual del entorno

El entorno ya ha sido instalado y validado.

### Completado

- WSL2 instalado.
- Rocky Linux 8.10 importado en WSL2.
- Usuario Linux configurado.
- Solido Simulation Suite instalado.
- QuestaSim operativo.
- Questa ADMS instalado.
- Symphony instalado.
- AFS operativo.
- `.bashrc` configurado.
- Acceso al servidor de licencias mediante VPN validado.
- Simulación SystemVerilog simple realizada correctamente.
- Simulación Verilog-A simple realizada correctamente.

### Ruta efectiva de instalación

```text
/eda/SolidoSimulationSuite/solidosim/solidosim/
```

### Usuario Linux

```text
jalberic
```

### Entrada en Rocky

Desde PowerShell:

```powershell
wsl -d Rocky-8.10
```

---

## 7. Licenciamiento

Las herramientas Siemens utilizan un servidor de licencias accesible mediante VPN.

Servidor configurado:

```text
29000@158.42.1.112
```

Comprobación de conectividad:

```bash
timeout 5 bash -c '</dev/tcp/158.42.1.112/29000' && echo OK || echo FALLO
```

La VPN debe estar conectada para ejecutar las herramientas que requieran licencia.

---

## 8. Conocimientos necesarios

Antes de afrontar la integración completa conviene dominar, al menos a nivel práctico:

### ADC

- Resolución.
- Vref.
- LSB.
- Cuantización.
- Saturación.
- Offset.
- Gain error.
- DNL.
- INL.
- Frecuencia de muestreo.

### SystemVerilog

- Módulos.
- Interfaces.
- Clases.
- Tasks y functions.
- Randomización.
- Constraints.

### UVM

- sequence_item.
- sequence.
- sequencer.
- driver.
- monitor.
- agent.
- env.
- scoreboard.
- test.
- phases.
- config_db.
- analysis ports.
- coverage.

### Verilog-A

- electrical.
- analog.
- V().
- I().
- parámetros `real`.
- eventos como `cross()`.

### Mixed-signal

- Diferencia entre dominio analógico y digital.
- Conversión de señales entre ambos dominios.
- Sincronización temporal.
- Papel de Questa ADMS, Symphony y AFS.

---

## 9. Estrategia de trabajo recomendada

El desarrollo debe seguir una estrategia incremental.

### Fase 1 — Validación independiente

- Validar QuestaSim con un diseño SystemVerilog simple.
- Validar AFS con un modelo Verilog-A simple.
- Validar el ADC Verilog-A de forma independiente.

### Fase 2 — UVM digital

- Crear un testbench UVM sencillo.
- Generar transacciones.
- Implementar driver.
- Implementar monitor.
- Implementar scoreboard.

### Fase 3 — Integración mixed-signal

- Conectar UVM con el ADC Verilog-A.
- Resolver las conversiones analógico/digital.
- Validar una conversión simple.

### Fase 4 — Verificación funcional

- Implementar modelo de referencia.
- Añadir tests dirigidos.
- Añadir tests aleatorios.
- Añadir assertions si procede.

### Fase 5 — Cobertura y regresión

- Crear covergroups.
- Ejecutar múltiples seeds.
- Identificar agujeros de cobertura.
- Añadir tests adicionales.

### Fase 6 — Resultados

- Recoger métricas.
- Generar tablas.
- Generar gráficas.
- Analizar errores y limitaciones.

---

## 10. Riesgos principales

### Riesgo 1 — Integración mixed-signal

Es probablemente el mayor riesgo técnico.

Posibles problemas:

- Conexión entre señales `electrical` y SystemVerilog.
- Configuración incorrecta de Questa ADMS / Symphony.
- Errores de sincronización temporal.
- Problemas con disciplinas o connect modules.
- Diferencias entre flujo puramente digital y mixed-signal.

Mitigación:

- Empezar con un ejemplo mixed-signal mínimo.
- No integrar directamente el ADC completo.
- Validar cada interfaz por separado.

---

### Riesgo 2 — Complejidad de UVM

UVM puede introducir mucha complejidad si se intenta implementar toda la arquitectura de golpe.

Mitigación:

- Crear primero un testbench UVM mínimo.
- Añadir componentes progresivamente.
- Evitar componentes innecesarios.

---

### Riesgo 3 — Modelo Verilog-A poco documentado

El ADC puede contener comportamiento que no sea evidente a primera vista.

Posibles problemas:

- Parámetros poco claros.
- Temporización interna.
- Eventos dependientes de `cross()`.
- Comportamientos no ideales.
- Diferencias entre el modelo y un ADC ideal.

Mitigación:

- Analizar el modelo antes de escribir el scoreboard.
- Crear simulaciones analógicas independientes.
- Documentar cada entrada, salida y parámetro.

---

### Riesgo 4 — Modelo de referencia incorrecto

Un scoreboard solo es útil si el resultado esperado es correcto.

Mitigación:

- Definir matemáticamente la función del ADC.
- Validar el modelo de referencia con casos manuales.
- Probar valores cercanos a transiciones de código.

---

### Riesgo 5 — Licencias

La simulación depende de un servidor externo accesible por VPN.

Posibles problemas:

- VPN desconectada.
- Licencias ocupadas.
- Cambios de red.
- WSL sin acceso al servidor.

Mitigación:

- Comprobar conectividad antes de cada sesión.
- Guardar logs.
- Separar problemas de licencia de problemas del testbench.

---

### Riesgo 6 — Dependencias del entorno Linux

Las herramientas EDA requieren librerías del sistema.

Ya se han encontrado ejemplos como:

- libXext.
- libXrender.
- libXtst.
- libXi.
- libXft.
- libgomp.
- glibc-devel.

Mitigación:

- Mantener documentados los paquetes instalados.
- Evitar actualizar la distribución sin necesidad.
- Mantener Rocky Linux 8.10 como entorno estable.

---

### Riesgo 7 — Alcance excesivo

Intentar verificar demasiadas métricas puede hacer que el proyecto se vuelva demasiado grande.

Mitigación:

Definir dos niveles:

#### Objetivo mínimo

- Conversión correcta.
- Límites.
- Saturación.
- Barrido.
- Tests aleatorios.
- Scoreboard.
- Cobertura funcional.

#### Objetivos adicionales

- INL.
- DNL.
- ENOB.
- SNR.
- SINAD.
- THD.

Los objetivos adicionales solo deben abordarse cuando el flujo básico esté totalmente estable.

---

### Riesgo 8 — Tiempo de simulación

Las simulaciones mixed-signal pueden ser significativamente más lentas que las digitales.

Mitigación:

- Usar tests pequeños durante desarrollo.
- Reservar regresiones largas para fases posteriores.
- Evitar guardar señales innecesarias.
- Reducir la duración de simulación cuando sea posible.

---

## 11. Riesgo de planificación

La estimación inicial para completar el proyecto es aproximadamente:

```text
8–12 semanas
```

con trabajo constante.

La integración mixed-signal es la parte que más incertidumbre introduce.

El camino crítico es:

```text
ADC
 ↓
Verilog-A
 ↓
UVM básico
 ↓
Mixed-signal
 ↓
UVM + ADC
 ↓
Scoreboard
 ↓
Tests
 ↓
Cobertura
 ↓
Resultados
```

---

## 12. Criterios de éxito

El proyecto puede considerarse técnicamente satisfactorio cuando:

- El ADC Verilog-A se simula correctamente.
- El entorno UVM genera estímulos.
- El DUT recibe correctamente esos estímulos.
- El monitor captura las conversiones.
- El modelo de referencia calcula el resultado esperado.
- El scoreboard compara automáticamente ambos resultados.
- Existen tests dirigidos.
- Existen tests aleatorios.
- La cobertura funcional se mide.
- Las simulaciones pueden repetirse de forma reproducible.

El resultado ideal es disponer de un comando o script que permita lanzar una verificación completa sin intervención manual.

Ejemplo:

```bash
make test
```

---

## 13. Organización recomendada del repositorio

```text
tfg-adc-uvm/
├── veriloga/
│   └── adc.va
├── tb/
│   ├── agents/
│   ├── sequences/
│   ├── scoreboard/
│   ├── env/
│   └── tests/
├── sim/
├── scripts/
├── results/
├── docs/
└── README.md
```

No deben subirse al repositorio:

- Librerías compiladas.
- Archivos temporales.
- Logs grandes.
- Dumps de ondas innecesarios.
- Software de Siemens.
- Archivos de licencia.

---

## 14. Principios de desarrollo

1. Validar cada capa antes de añadir la siguiente.
2. No depurar UVM y Verilog-A simultáneamente si puede evitarse.
3. Mantener el ADC, el modelo de referencia y el scoreboard conceptualmente separados.
4. Automatizar desde el principio.
5. Guardar seeds de simulaciones aleatorias.
6. Mantener Git como fuente principal del código.
7. Documentar decisiones importantes.
8. Priorizar reproducibilidad frente a configuraciones manuales.
9. Mantener el alcance bajo control.
10. Diferenciar siempre entre error del DUT, error del testbench y error del entorno.

---

## 15. Preguntas abiertas

Estas cuestiones deberán resolverse durante el desarrollo:

- ¿Cuál es la resolución exacta del ADC?
- ¿Cuál es su Vref?
- ¿Qué interfaz digital utiliza?
- ¿Cómo se realiza el muestreo?
- ¿Existe señal de reloj?
- ¿Existe señal de inicio de conversión?
- ¿Existe señal de fin de conversión?
- ¿Qué no idealidades incorpora el modelo Verilog-A?
- ¿Qué métricas son obligatorias en el TFG?
- ¿Qué nivel de cobertura se considera suficiente?
- ¿Qué connect modules o interfaces recomienda Siemens para este flujo?
- ¿Qué parte de la verificación debe ser puramente UVM y qué parte debe permanecer en el entorno analógico?

---

## 16. Uso de este documento

Este archivo debe utilizarse como documento de referencia común para los distintos chats, scripts y documentos del proyecto.

Cuando se abra un nuevo hilo de trabajo, este documento puede servir para proporcionar:

- Objetivo del TFG.
- Estado actual.
- Herramientas utilizadas.
- Arquitectura prevista.
- Riesgos conocidos.
- Decisiones ya tomadas.
- Límites de alcance.
- Próximos pasos.

Debe actualizarse cuando cambien decisiones importantes del proyecto.
