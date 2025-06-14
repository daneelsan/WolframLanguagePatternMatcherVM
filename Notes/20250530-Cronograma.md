# Cronograma Detallado para Desarrollo de Tesis  
**Título:** Implementación de Máquina Virtual para Pattern Matching en Wolfram Language  
**Duración:** Marzo - Noviembre 2024  

## 📅 Cronograma Semanal por Fases  

### 🗂 **Fase 1: Investigación y Diseño (Marzo - Mayo)**  
**Objetivo:** Establecer bases teóricas y diseño técnico  

| Semana       | Tareas Específicas                                                                    | Entregables                              |
|--------------|---------------------------------------------------------------------------------------|------------------------------------------|
| **25-31 Mar**| - Revisión bibliográfica preliminar <br>- Estudio de problemática                     | Cronograma tentativo (31 Mar)            |
| **1-7 Abr**  | - Estudio de estado actual del pattern matcher<br>-Análisis de patrones WL frecuentes | Notebook con puntos clave de implementación actual del pattern matcher|
| **8-14 Abr** | - Definición de objetivos<br>- Diagramas de flujo de ejecución                        | Objetivo General y específicos           |
| **15-21 Abr**| - Redacción de problemática<br>- Justificación técnica                                | **Reporte Técnico 1** (21 Abr)           |
| **22-28 Abr**| - Revisión bibliográfica (libros, artículos, documentación en web)                    |                                          |
| **29 Abr-5 May**| - Definición de resultados esperados<br>- Revisión bibliográfica (cont.)           | Excel con extracción de datos            |
| **6-12 May** | - Redacción de proyecto de investigación<br>                                          | **Reporte Técnico 2** (9 May)            |
| **13-19 May**| - Revisión final con asesor<br>- Preparación presentación                             | **Proyecto investigación (16 May)**      |
| **20-24 May**| - **Presentación Parcial Presencial**<br>- Correción de anotaciones del asesor        | Slides + exposición                      |
| **26-01 Jun**| - Setup de la implementación como paclet de WL<br>- Desarrollo de herramienta que convierta patrones a `Function`                                                                                    | Código fuente (Github) + Notebook                      |

- Especificación formal de instrucciones
- Diseño del front-end (parser)
- Optimización del IR
- Integración de diseño modular
- Documentación completa

---

### 💻 **Fase 2: Implementación 1 (Junio - Agosto)**  
**Objetivo:** Desarrollo de componentes funcionales  

| Semana       | Tareas Específicas                                                                 | Entregables                               |
|--------------|------------------------------------------------------------------------------------|-------------------------------------------|
| **3-9 Jun**  | - Especificación tentativa del ISA<br>- Implementación inicial del paclet (cont.)  | Borrador del ISA (notebook) + Paclet      |
| **10-16 Jun**| - Diseño inicial de la máquina virtual<br>- Diseño de registros de memoria         | **Reporte Técnico 3**                     |
| **17-23 Jun**| - Diseño e implementación inicial de compilación de patrón a bytecode              | Funcion `CompilePattern[...]` en paclet   |
| **24-30 Jun**| - Diseño e implementación inicial de ejecución de bytecode                         | Funcion `VMMatchQExecute[...]` en paclet  |
| **1-7 Jul**  | - Workflow inicial de front-end -> back-end usando funciones del paclet            | **Reporte Técnico 4**                     |
| **8-14 Jul** | - Extensión del ISA y de semántica del bytecode                                    | Pruebas unitarias                         |
| **15-19 Jul**| - **Presentación Final Presencial**                                                | Prototipo funcional + slides              |

---

### 🧪 **Fase 3: Validación y Escritura (Septiembre - Noviembre)**  
**Objetivo:** Evaluación sistemática y redacción final  

| Semana       | Tareas Específicas                                                                 | Entregables                              |
|--------------|------------------------------------------------------------------------------------|------------------------------------------|
| **22-26 Jul**| - Memory pooling<br>- Optimización de saltos                                       | Resultados rendimiento                   |
| **29 Jul-2 Ago**| - Manejo de errores<br>- Logging detallado                                      | Sistema de diagnóstico                   |
| **5-9 Ago**  | - Pruebas de estrés (1M iteraciones)<br>- Ajuste de parámetros                     | Reporte de estabilidad                   |
| **2-6 Sep**  | - Benchmarking vs. implementación nativa<br>- Pruebas de regresión                 | Tablas comparativas                      |
| **9-13 Sep** | - Análisis estadístico resultados<br>- Gráficos de rendimiento                     | **Reporte Técnico 5** (9 Sep)            |
| **16-20 Sep**| - Redacción Cap. 4 (Resultados)<br>- Conclusiones preliminares                    | Borrador completo                        |
| **23-27 Sep**| - Revisión de estilo<br>- Normalización APA                                        | Documento formateado                     |
| **30 Sep-4 Oct**| - Validación cruzada con expertos<br>- Correcciones finales                     | **Reporte Técnico 6** (4 Oct)            |
| **7-11 Oct** | - Preparación de defensa<br>- Slides ejecutivas                                    | Presentación final                       |
| **14-18 Oct**| - Encuadernación documento<br>- Entrega física                                     | Copia impresa (18 Oct)                   |
| **21-25 Oct**| - **Entrega Final Digital**                                                       | PDF + repositorio código                 |
| **Nov**      | - **Defensa Pública**                                                             | Sustentación ante jurado                 |

---



# V2

## Fase 1: Fundamentos y Diseño (Marzo – Mayo)

**Objetivo**: Comprender el sistema actual, definir objetivos, resultados esperados y sentar las bases técnicas.

| Semana           | Tareas Específicas                                                                                         | Entregables                              |
| ---------------- | ---------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| **25–31 Mar**    | - Revisión bibliográfica preliminar<br>- Análisis de la problemática<br>- Elaboración del cronograma       | Cronograma tentativo (31 Mar)            |
| **1–7 Abr**      | - Estudio del pattern matcher actual en WL<br>- Identificación de patrones frecuentes y cuellos de botella | Notebook técnico sobre sistema actual    |
| **8–14 Abr**     | - Definición de objetivos general y específicos<br>- Primeros diagramas de arquitectura                    | Documento de objetivos                   |
| **15–21 Abr**    | - Redacción de problemática y justificación técnica<br>- Consolidación de hallazgos previos                | **Reporte Técnico 1** (21 Abr)           |
| **22–28 Abr**    | - Revisión bibliográfica (artículos clave, regex, Prolog, compiladores)                                    | Base de datos de referencias             |
| **29 Abr–5 May** | - Definición y formalización de resultados esperados<br>- Análisis de métodos comparables                  | Tabla de resultados esperados            |
| **6–12 May**     | - Redacción del documento de proyecto de investigación                                                     | **Reporte Técnico 2** (9 May)            |
| **13–19 May**    | - Revisión final con asesor<br>- Preparación de presentación parcial                                       | Proyecto investigación completo (16 May) |
| **20–24 May**    | - **Presentación Parcial**<br>- Corrección de observaciones del asesor                                     | Slides + feedback recibido               |
| **26 May–1 Jun** | - Configuración inicial del *paclet* de WL<br>- Implementación de parser a `Function`                      | Estructura de paclet en GitHub           |

## Fase 2: Implementación Modular (Junio – Julio)

**Objetivo**: Implementar la arquitectura modular de la máquina virtual (front-end, middle-end, back-end).

| Semana        | Tareas Específicas                                                                          | Entregables                                  |
| ------------- | ------------------------------------------------------------------------------------------- | -------------------------------------------- |
| **3–9 Jun**   | - Especificación inicial del ISA<br>- Diseño textual del conjunto de instrucciones          | Borrador del ISA + representación textual    |
| **10–16 Jun** | - Implementación de registros y semántica básica de ejecución<br>- Arquitectura del loop VM | **Reporte Técnico 3**                        |
| **17–23 Jun** | - Implementación de compilador de patrones a IR<br>- Primera versión de `PatternToIR`       | Función `PatternToIR` + pruebas unitarias    |
| **24–30 Jun** | - Implementación de compilador de IR a bytecode<br>- `IRToBytecode` + trazado               | Función `IRToBytecode` + notebook de tracing |
| **1–7 Jul**   | - Implementación inicial del motor de ejecución (`VMExecute`)                               | **Reporte Técnico 4**                        |
| **15–19 Jul** | - **Presentación Final Intermedia**                                                         | Prototipo funcional + slides                 |

## Fase 3: Optimización y Validación (Julio - Agosto – Septiembre)

**Objetivo**: Verificar semántica, medir rendimiento y aplicar optimizaciones al IR.

| Semana           | Tareas Específicas                                                                      | Entregables                                 |
| ---------------- | --------------------------------------------------------------------------------------- | ------------------------------------------- |
| **22–28 Jul**    | - (cont.) Implementación del motor de ejecución (`VMExecute`)                           | VM funcional básica                         |
| **29 Jul–4 Ago** | - Ampliación del ISA para patrones más complejos<br>- Diseño de logging de ejecución    | Pruebas de captura de registros + tracing   |
| **5–11 Ago**     | - Implementación del optimizador de IR<br>- Reglas básicas: eliminación de redundancias | Optimización activa en `OptimizeIR`         |
| **12–18 Ago**    | - Logging de optimizaciones aplicadas<br>- Comparación semántica pre/post optimización  | Estadísticas de reducción + equivalencia    |
| **19–25 Ago**    | - Validación de equivalencia con `MatchQ`, `ReplaceAll`                                 | Casos de prueba + Wolfram Testing Framework |
| **26 Ago–1 Sep** | - Benchmarking: ejecución profunda, uso de memoria                                      | Gráficas comparativas de rendimiento        |
| **2-8 Sep**      | - Revisión y estabilización del prototipo                                               | Versión beta de paclet                      |

## Fase 4: Documentación y Cierre (Septiembre – Diciembre)

**Objetivo**: Entregar documentación final, analizar resultados y preparar defensa.

| Semana           | Tareas Específicas                                              | Entregables                      |
| ---------------- | --------------------------------------------------------------- | -------------------------------- |
|                  | - Redacción de documentación técnica (ISA, IR, optimizador, VM) | Manual técnico del sistema       |
|                  | - Análisis crítico de resultados<br>- Revisión con asesor       | Informe de resultados + feedback |
|                  | - Preparación de presentación final<br>- Ensayo de defensa      | Slides finales + simulacro       |
|                  | - **Defensa del proyecto**                                      | Presentación final               |
|                  | - Entrega de documento final corregido                          | Tesis entregada                  |
