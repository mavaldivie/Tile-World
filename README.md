# Tile-World

---
## Proyecto de simulación escrito en haskell para propósitos académicos
### Abstract: Tile-World Simulation Project built in haskell for academic purposes

---

**Nombre y Apellidos:** Marcos Adrián Valdivié Rodríguez  

**Grupo:** C-412

**Email:** marcos.valdivie@estudiantes.matcom.uh.cu

**Github:** https://github.com/mavaldivie/Tile-World

---
### 1. Orden del Proyecto

Cada estudiante debe realizar la implementación del problema presentado. Esta implementación se debe realizar en Haskell y la solución debe estar en un repositorio de Github. La URL del proyecto debe entregarse por correo electrónico al profesor de conferencia de Simulación (yudy@matcom.uh.cu) con copia a la profesora de conferencia de Programación Declarativa (dafne@matcom.uh.cu), antes del viernes 28 de enero a las 12:00 de la noche. Junto a la implementación, en el proyecto de Github, debe estar presente el informe del trabajo (un documento en formato pdf). El informe de trabajo debe contener los siguientes elementos: 

- Generales del Estudiante 
- Orden del Problema Asignado 
- Principales Ideas seguidas para la solución del problema 
- Modelos de Agentes considerados (por cada agente se deben presentar dos modelos diferentes) 
- Ideas seguidas para la implementación 
- Consideraciones obtenidas a partir de la ejecución de las simulaciones del problema (determinar a partir de la experimentación cuáles fueron los modelos de agentes que mejor funcionaron).

#### Descripción del problema

El ambiente en el cual intervienen los agentes es discreto y tiene la forma de un rectángulo de N × M. El ambiente es de información completa, por tanto todos los agentes conocen toda la información sobre el agente. El ambiente puede varı́ar aleatoriamente cada t unidades de tiempo. El valor de t es conocido. 

Las acciones que realizan los agentes ocurren por turnos. En un turno, los agentes realizan sus acciones, una sola por cada agente, y modifican el medio sin que este varı́e a no ser que cambie por una acción de los agentes. En el siguiente, el ambiente puede variar. Si es el momento de cambio del ambiente, ocurre primero el cambio natural del ambiente y luego la variación aleatoria. En una unidad de tiempo ocurren el turno del agente y el turno de cambio del ambiente.

Los elementos que pueden existir en el ambiente son obstáculos, suciedad, niños, el corral y los agentes que son llamados Robots de Casa. A continuación se precisan las caracterı́sticas de los elementos del ambiente:

**Obstáculos:** estos ocupan una única casilla en el ambiente. Ellos pueden ser movidos, empujándolos, por los niños, una única casilla. El Robot de Casa sin embargo no puede moverlo. No pueden ser movidos ninguna de las casillas ocupadas por cualquier otro elemento del ambiente.

**Suciedad:** la suciedad es por cada casilla del ambiente. Solo puede aparecer en casillas que previamente estuvieron vacı́as. Esta, o aparece en el estado inicial o es creada por los niños.

**Corral:** el corral ocupa casillas adyacentes en número igual al del total de niños presentes en el ambiente. El corral no puede moverse. En una casilla del corral solo puede coexistir un niño. En una casilla del corral, que esté vacı́a, puede entrar un robot. En una misma casilla del corral pueden coexistir un niño y un robot solo si el robot lo carga, o si acaba de dejar al niño.

**Niño:** los niños ocupan solo una casilla. Ellos en el turno del ambiente se mueven, si es posible (si la casilla no está ocupada: no tiene suciedad, no está el corral, no hay un Robot de Casa), y aleatoriamente (puede que no ocurra movimiento), a una de las casilla adyacentes. Si esa casilla está ocupada por un obstáculo este es empujado por el niño, si en la dirección hay más de un obstáculo, entonces se desplazan todos. Si el obstáculo está en una posición donde no puede ser empujado y el niño lo intenta, entonces el obstáculo no se mueve y el niño ocupa la misma posición. Los niños son los responsables de que aparezla suciedad. Si en una cuadrı́cula de 3 por 3 hay un solo niño, entonces, luego de que él se mueva aleatoriamente, una de las casillas de la cuadrı́cula anterior que esté vacı́a puede haber sido ensuciada. Si hay dos niños se pueden ensuciar hasta 3. Si hay tres niños o más pueden resultar sucias hasta 6. Los niños cuando están en una casilla del corral, ni se mueven ni ensucian. Si un niño es capturado por un Robot de Casa tampoco se mueve ni ensucia.

**Robot de Casa:** El Robot de Casa se encarga de limpiar y de controlar a los niños. El Robot se mueve a una de las casillas adyacentee, las que decida. Solo se mueve una casilla sino carga un niño. Si carga un niño pude moverse hasta dos casillas consecutivas. También puede realizar las acciones de limpiar y cargar niños. Si se mueve a una casilla con suciedad, en el próximo turno puede decidir limpiar o moverse. Si se mueve a una casilla donde está un niño, inmediatamente lo carga. En ese momento, coexisten en la casilla Robot y niño. Si se mueve a una casilla del corral que está vacı́a, y carga un niño, puede decidir si lo deja esta casilla o se sigue moviendo. El Robot puede dejar al niño que carga en cualquier casilla. En ese momento cesa el movimiento del Robot en el turno, y coexisten hasta el próximo turno, en la misma casilla, Robot y niño.

---
### 2. Principales ideas para la implementación del problema

Se explicará las principales idea seguidas para la implementación de cada uno de los módulos que conforman la solución, además de como estos se conectan para el resultado final.

#### Módulo ```Configuration.hs```

Este módulo guarda los valores de configuración que son usados para la construccion del tablero del ambiente, se decidió implementarlo en un módulo separado y con la mínima cantidad de lógica necesaria para que pueda ser usado para cambiar los parámetros desde cualquier editor de textos. En este módulo se guardan los valores correspondientes a la cantidad de niños, robots, el intervalo de cambio aleatorio del ambiente y las magnitudes del tablero y del corral. 

#### Módulo ```Random.hs```

Este módulo contiene la lógica para la simulación de las variables aleatorias utilizadas durante la ejecución del problema. 

- El Monad rand recibe un entero m como parámetro y se usa para simular una variable aleatoria discreta entre 0 y m-1.
- El Monad ber se utiliza para simular una variable aleatoria discreta (0,1).
- El Monad randomSelect se utiliza para escoger, dado un Int n y una lista, n elementos aleatorios distintos de dicha lista.

Toda la simulación de variables aleatorias se basa en la obtención de la cantidad de milisegundos del reloj de la máquina utilizando el módulo ```Data.Time.Clock(getCurrentTime)```.

#### Módulo ```Init.hs```

Este módulo se encarga de la inicialización del tablero del ambiente. 

- El Monad initBoard se encarga de crear una nueva instancia del tablero con la cantidad de elementos de cada tipo especificado en el módulo ```Configuration.hs```. Es necesario destacar que las casillas de la esquina superior izquierda del tablero estarán siempre dedicadas al Corral, y los demás elementos serán distribuidos aleatoriamente por las casillas restantes.
- El Monad shuffle se encarga de modificar de manera aleatoria los elementos del tablero, esto es usado para simular la variación aleatoria del tablero cada cierto tiempo.
- La función validateBoard se utiliza para verificar que los parámetros dados para la construcción del tablero inicial satisfacen las condiciones del problema, es decir, que la cantidad de casillas del corral se mayor igual que la cantidad de niños y que la cantidad de elementos iniciales en total se menor igual que la cantidad de casillas del tablero.

#### Módulo ```Types.hs```

Este módulo contiene las definiciones de los tipos que son usados en el programa y define la forma de imprimirlos al implementar la clase Eq de cada uno.

- El tipo Matrix a que es un alias del tipo Array (Int,Int) a definido en el módulo Data.Array. Además de definieron funciones para extraer información de dichas matrices como su tamaño.
- El módulo Cell que se utiliza para representar el estado de cada una de las casillas del tablero. 
- El ambiente es representado en el programa con el tipo Board como un alias a ```Matrix Cell```.

Se definieron dos tipos de robots, StateRobot y ReactiveRobot, siguiendo dos modelos de agentes distintos.

Para la representación en consola de cada uno de los elementos del tablero se siguió el siguiente patrón:

- Obstacle            = #
- Muck                = * 
- Child               = C
- House               = ^
- Empty               = _
- ChildHouse          = B
- ReactiveRobot       = R
- ChildReactiveRobot  = %
- MuckReactiveRobot   = r
- StateRobot          = S
- ChildStateRobot     = %
- MuckStateRobot      = r

#### Módulo ```Moves.hs```

Este módulo consta de tres funciones básicas para la modificación del tablero.

- moveTo b p e mueve el elemento que está en la posición p del tablero b a la posición e. Si en la posición e hay algún elemento distinto de Empty, entonces el uso de este método ocasionaría que se perdiera la información sobre dicho elemento.
- put b p x coloca en la posici'on p del tablero un elemento de tipo x, sobrescribiendo el elemento que había anteriormente.
- clean b p coloca en la posición p del tablero b el elemento Empty, sobrescribiendo el elementoque había anteriormente.

#### Módulo ```Utils.hs```

Este módulo posee la lógica básica para el movimiento dentro del tablero.

- La función insideBoard que retorna si la posición actual se encuentra o no dentro del tablero.
- El tipo Pos que es un alias a (Int,Int) y se utiliza para representar las distintas posiciones o casillas del tablero.
- El tipo Mov que puede ser L, R, U, D, representando izquierda, derecha, arriba y debajo y define las distintas direcciones en que se puede mover un elemento del tablero.
- Las funciones adjacents and around que se utilizan para obtener dada una posición las casillas a los que se puede mover y las casillas que se encuentran alrededor de la posición dada respectivamente.
- La función oo que se utiliza para obtener un Int con valor bien grande.

#### Módulo ```Main.hs```



