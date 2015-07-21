# Trabajo Final - Algoritmos UNQ 2015

por Nahuel Garbezza

## Introducción

El objetivo del trabajo es realizar una implementación de un algoritmo Branch and Bound para
resolver el problema del viajante de comercio (en inglés, TSP: Traveling Salesman Problem).

## Descripción de la solución

Se aplicó un algoritmo branch and bound de las siguientes características:

- El criterio de branching es binario: la rama izquierda impone la restricción de que un eje
  x->y debe estar en el camino, y la rama derecha impone la restricción de que un eje x->y no
  debe estar en el camino.
- Los nodos por procesar se guardan en una lista. El criterio de cuál nodo elegir es configurable
  de 3 maneras: si elige los últimos nodos que procesó primero, o los últimos nodos último, o al
  azar. También se puede elegir qué rama procesar primero, si la rama izquierda (que representa
  incluir un eje) o la rama derecha (que representa excluir un eje), Estas variantes permitieron
  explorar diferentes comportamientos en diferentes ejemplos.
- Cada nodo contiene la siguiente información:
    - El nodo padre
    - El resultado de la cota inferior y superior
    - El tour formado hasta el momento
    - La distancia total calculada hasta el momento
    - Un objeto que maneja las restricciones de inclusión/exclusión
- La poda se intenta realizar en cada paso, teniendo en cuenta los datos de las mejores cotas
  inferior y superior, y si la cota inferior corresponde a una solución válida (en cuyo caso,
  también se puede usar para podar).

### Cota superior

Se calculó usando la heurística del vecino más cercano. Esta consiste en lo siguiente: posicionado
en una ciudad arbitraria, seguir el camino más corto hacia otra ciudad no visitada, y repetir hasta
llegar a la ciudad inicial. A medida que se van imponiendo restricciones en el árbol de soluciones,
las decisiones son cada vez más acotadas.

Las restricciones de exclusión (las del tipo: el eje x->y no puede formar parte de la solución),
complicaron un poco el algoritmo. Lo que podía suceder es que se llegue siguiendo el camino más corto
a un lugar del que después no se pueda volver a causa de las restricciones. Lo que realiza el algoritmo
es: cuando detecta esta situación, vuelve al punto en donde tomó una decisión, y simplemente toma otra.
Para ello se guarda para cada ciudad, las ciudades posibles a dónde ir, y esa lista se va actualizando
a medida que las soluciones se van restringiendo. Si se agotan todos los caminos posibles, se retorna
que no se pudo calcular la cota, entonces el nodo que estaba siendo procesado no puede procesarse más
y simplemente es descartado (podado del árbol).

### Cota inferior

Se experimentaron dos formas distintas de obtener cotas inferiores. Para probar el algoritmo se debe
optar por alguna de las dos.

- **Suma de pares de ejes con menor peso**: Esta relajación del problema es sencilla de calcular.
  Consiste en tomar, para cada ciudad, los dos ejes con menor peso incidentes a ese vértice, luego
  sumar todos los ejes obtenidos y dividir ese resultado por dos. Obviamente, esto la mayoría de las
  veces no da un tour válido, y por eso se dice que es una relajación del problema. A medida que se
  van imponiendo restricciones, este algoritmo las tiene en cuenta, y en el caso en donde todas las
  restricciones posibles están impuestas (es decir, el tour debe ser de una manera y no de otra) el
  resultado de este algoritmo coincide con el de la cota superior.
- **Algoritmo de asignación (o "Algoritmo Húngaro")**: Esta relajación fue la recomendada por la
  materia para utilizar, y se utilizó una versión para Ruby actualmente implementada (https://github.com/pdamer/munkres).
  La adaptación no costó demasiado, pero tuvo la gran desventaja de ser ineficiente y, a pesar de dar
  resultados de cotas mucho mejores que la relajación anterior, aumentó el tiempo de ejecución y en
  los profilings realizados durante las pruebas, se ve que el 76% del tiempo de todo el branch and bound
  se pierde calculando esta cota.

## Problemas enfrentados durante la resolución

- Dificultad para debuggear ejemplos grandes: en tantos pasos del algoritmo es difícil
  tener información del contexto y detectar errores u oportunidades de mejora.
- En un primer enfoque se intentó realizar una inferencia de los ejes que debían incluirse
  o excluirse como consecuencia de imponer alguna restricción. El objetivo era
  satisfacer en todo momento el invariante que debe tener todo TSP para ser válido (por cada
  ciudad, tener un sólo camino de entrada y de salida, y cubrir todas las ciudades en el tour
  completo). Esta inferencia era costosa, porque tenía que recorrer la matriz de restricciones
  y realizar varias modificaciones y detección de ciclos.
- Un segundo enfoque imponía demasiada libertad respecto de los ejes que se eligen,
  lo cual hacía más difícil el cálculo de la cota superior. Luego lo que se hizo fue que el
  próximo eje a elegir sea alguno que conecte el vértice último que fue elegido, de esta manera
  se puede llevar en cada nodo, la información del tour actual, y la distancia total precalculada.
  Obviamente, esta decisión restringe varias posibilidades de brancheo, pero agrega demasiada
  complejidad al algoritmo.
- El lenguaje elegido, Ruby. Si bien en la versión 2.2.2 (la última versión, y la utilizada en
  este trabajo) se realizaron varias mejoras en cuanto a la performance, aún sigue siendo poco
  útil para resolver este tipo de problemas.
- El Garbage Collector de Ruby consumió el 16% del tiempo total medido en la mayoría de los ejemplos,
  y no se pudo encontrar una mejor configuración (http://thorstenball.com/blog/2014/03/12/watching-understanding-ruby-2.1-garbage-collector/)
- Algoritmo húngaro para calcular la cota inferior está implementado de manera muy ineficiente.
- Memory leaks causados por la forma en la que los nodos se conocían. Cada nodo conocía a su nodo
  padre, y a su hijo izquierdo y derecho. Cuando se podaba algún nodo, la referencia al nodo padre
  hacía que no pueda ser limpiado por el GC, lo cual hacía incrementar el consumo de memoria hasta
  colgar la computadora a los pocos minutos. Una vez detectada esta situación, se removió las
  referencias al nodo padre, ya que no eran necesarias en la implementación.

## Detalle de pruebas realizadas

Para cada prueba se midió el tiempo total de ejecución usando el módulo de benchmarking incluido en
las librerías estándar de Ruby. Para el profiling, se utilizó la herramienta perftools.rb (https://rubygems.org/gems/perftools.rb).
Se adjuntan gráficos que muestran los tiempos de ejecución más altos, y las relaciones entre los mismos.

### Ejemplo de 11 ciudades

Tour óptimo [0, 7, 4, 3, 9, 5, 2, 6, 1, 10, 8, 0], distancia 253

- Prueba 1
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: suma de pares de ejes con menor peso
    - **Elección de nodos**: últimos en la rama derecha primero
    - **Cantidad de nodos en el árbol**: 291497
    - **Finalizó con valor óptimo**: sí
    - **Tiempo total**: 114.334399 s

- Prueba 2
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: algoritmo húngaro
    - **Elección de nodos**: últimos en la rama derecha primero
    - **Cantidad de nodos en el árbol**: 113143
    - **Finalizó con valor óptimo**: sí
    - **Tiempo total**: 203.533104 s

- Prueba 3: similar a prueba 1 pero sin output de consola en cada paso del algoritmo
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: suma de pares de ejes con menor peso
    - **Elección de nodos**: últimos en la rama derecha primero
    - **Cantidad de nodos en el árbol**: 291497
    - **Finalizó con valor óptimo**: sí
    - **Tiempo total**: 84.483877 s

- Prueba 4: similar a prueba 3 pero con pequeñas optimizaciones de performance en algunos métodos
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: suma de pares de ejes con menor peso
    - **Elección de nodos**: últimos en la rama derecha primero
    - **Cantidad de nodos en el árbol**: 291497
    - **Finalizó con valor óptimo**: sí
    - **Tiempo total**: 67.169276 s

- Prueba 5: similar a prueba 2 pero sin output de consola en cada paso, y con las pequeñas optimizaciones de
performance también incluidas de la prueba 3
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: algoritmo húngaro
    - **Elección de nodos**: últimos en la rama derecha primero
    - **Cantidad de nodos en el árbol**: 113143
    - **Finalizó con valor óptimo**: sí
    - **Tiempo total**: 175.111972 s

### Ejemplo de 16 ciudades

Tour óptimo [0, 13, 12, 11, 6, 5, 14, 4, 10, 8, 9, 15, 2, 1, 3, 7, 0], distancia 6859

- Prueba 6:
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: algoritmo húngaro
    - **Elección de nodos**: al azar
    - **Cantidad de nodos en el árbol**: 58340
    - **Finalizó con valor óptimo**: no
    - **Mejor resultado obtenido**: tour [0, 2, 1, 3, 7, 6, 5, 9, 8, 10, 4, 14, 13, 12, 11, 15, 0], distancia 7077
    - **Tiempo total**: 290s

- Prueba 7:
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: suma de pares de ejes con menor peso
    - **Elección de nodos**: últimos en la rama derecha primero
    - **Cantidad de nodos en el árbol**: 761632
    - **Finalizó con valor óptimo**: no
    - **Mejor resultado obtenido**: tour [0, 2, 1, 3, 7, 15, 12, 13, 11, 6, 5, 14, 4, 9, 8, 10, 0], distancia 8026
    - **Tiempo total**: 594s

### Ejemplo de 29 ciudades

Tour óptimo [0, 27, 5, 11, 8, 25, 2, 28, 4, 20, 1, 19, 9, 3, 14, 17, 13, 16, 21, 10, 18, 24, 6, 22, 7, 26, 15, 12, 23, 0], distancia 1610

- Prueba 8:
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: algoritmo húngaro
    - **Elección de nodos**: primeros en la rama izquierda primero
    - **Cantidad de nodos en el árbol**: 147
    - **Finalizó con valor óptimo**: no
    - **Mejor resultado obtenido**: tour [0, 27, 5, 11, 8, 4, 20, 1, 19, 9, 3, 14, 18, 24, 6, 22, 26, 23, 7, 15, 12, 17, 13, 21, 16, 10, 28, 2, 25, 0], distancia 1960
    - **Tiempo total**: 0.940994s

- Prueba 9:
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: algoritmo húngaro
    - **Elección de nodos**: al azar
    - **Cantidad de nodos en el árbol**: 9749
    - **Finalizó con valor óptimo**: no
    - **Mejor resultado obtenido**: tour [0, 5, 12, 9, 19, 1, 20, 4, 8, 25, 28, 2, 11, 27, 7, 26, 23, 15, 18, 14, 3, 17, 13, 21, 16, 10, 24, 6, 22, 0], distancia 1930
    - **Tiempo total**: 89.813231s

- Prueba 10:
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: algoritmo húngaro
    - **Elección de nodos**: últimos en la rama derecha primero
    - **Cantidad de nodos en el árbol**: 255
    - **Finalizó con valor óptimo**: no
    - **Mejor resultado obtenido**: tour [0, 27, 5, 11, 8, 4, 20, 1, 19, 9, 3, 14, 18, 24, 6, 22, 26, 23, 7, 15, 12, 17, 13, 21, 16, 10, 28, 2, 25, 0], distancia 1960 
    - **Tiempo total**: 2.170210s
    
## Conclusiones

- El problema en su planteo teórico es sencillo, pero posee muchas variantes a la hora de implementarlo, y cada
  una de ellas puede llevar a resultados muy diferentes.
- Al tener tantos pasos involucrados es difícil tener noción de la complejidad en general, con lo cual hay que
  asegurarse que cada una de las partes que componen el algoritmo no superen la complejidad polinomial.
- Los resultados a nivel tiempo de ejecución no fueron los esperados, producto de varias razones: en primer lugar,
  la performance en general de Ruby, y en segundo lugar, los algoritmos que no brindaron muy buenas cotas.
- El trabajo me permitió aprender sobre optimizaciones de implementación, y me brindó herramientas para poder
  eventualmente resolver otro tipo de problemas (más allá del problema del viajante de comercio) utilizando esta
  misma técnica de branch and bound.
- Es muy conveniente tener a mano las diferentes variantes para configurar el algoritmo (qué relajación utilizar,
  cómo ir procesando los nodos, etc), ya que no hay una sola que se comporte mejor para todos los casos de prueba.
- La información brindada por las herramientas de profiling de Ruby fueron muy útiles para realizar mejoras
  importantes, aunque no mejoraron drásticamente los resultados.
