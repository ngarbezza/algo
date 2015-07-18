# Trabajo Final - Algoritmos UNQ 2015

por Nahuel Garbezza

## Introducción

El objetivo del trabajo es realizar una implementación de un algoritmo Branch
and Bound para resolver el problema del viajante de comercio (en inglés, TSP:
Traveling Salesman Problem).

## Descripción de la solución

Se aplicó un algoritmo branch and bound de las siguientes características:

- El criterio de branching es binario: la rama izquierda impone la restricción
  de que un eje x->y debe estar en el camino, y la rama derecha impone la
  restricción de que un eje x->y no debe estar en el camino.
- El criterio de cuál nodo elegir es el siguiente: los nodos por procesar se
  guardan en una lista, y en el momento de ramificar se ponen ambos nodos resultantes
  en el tope de la lista (el derecho primero, luego el izquierdo), de manera que
  sean los próximos en procesarse. Esto es para lograr llegar en profundidad a una
  solución válida, que se puede utilizar para realizar mejores podas.
- Cada nodo contiene la siguiente información:
    - El nodo padre
    - El resultado de la cota inferior y superior
    - El tour formado hasta el momento
    - La distancia total calculada hasta el momento
    - Un objeto que maneja las restricciones de inclusión/exclusión
- La poda se intenta realizar en cada paso, teniendo en cuenta los datos de las
  mejores cotas inferior y superior, y si la cota inferior corresponde a una
  solución válida (en cuyo caso, también se puede usar para podar).
- 

### Cota superior

Se calculó usando la heurística del vecino más cercano. Esta consiste en

### Cota inferior

Se experimentaron dos formas distintas de obtener cotas inferiores. Para probar el
algoritmo se debe optar por alguna de las dos.

- **Suma de pares de ejes con menor peso**:
- **Algoritmo de asignación (o "Algoritmo Húngaro")**

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
- El lenguaje elegido: Ruby. Si bien en la versión 2.2.2 (la última versión, y la utilizada en
  este trabajo) se realizaron varias mejoras en cuanto a la performance, aún sigue siendo poco
  útil para resolver este tipo de problemas.
- El Garbage Collector de Ruby consumió el 16% del tiempo total medido en la mayoría de los ejemplos,
  y no se pudo encontrar una mejor configuración(http://thorstenball.com/blog/2014/03/12/watching-understanding-ruby-2.1-garbage-collector/)
- Algoritmo húngaro para calcular la cota inferior está implementado de manera muy ineficiente.

## Detalle de pruebas

### Ejemplo de 11 ciudades

- Prueba 1
    - **Tour**: 11 ciudades
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: suma de pares de ejes con menor peso
    - **Cantidad de nodos en el árbol**: 291497
    - **Finalizó con valor óptimo**: sí
    - **Tiempo total**: 114.334399 s

- Prueba 2
    - **Tour**: 11 ciudades
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: algoritmo húngaro
    - **Cantidad de nodos en el árbol**: 113143
    - **Finalizó con valor óptimo**: sí
    - **Tiempo total**: 203.533104 s

- Prueba 3: similar a prueba 1 pero sin output de consola en cada paso del algoritmo
    - **Tour**: 11 ciudades
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: suma de pares de ejes con menor peso
    - **Cantidad de nodos en el árbol**: 291497
    - **Finalizó con valor óptimo**: sí
    - **Tiempo total**: 84.483877 s

- Prueba 4: similar a prueba 3 pero con pequeñas optimizaciones de performance en algunos métodos
    - **Tour**: 11 ciudades
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: suma de pares de ejes con menor peso
    - **Cantidad de nodos en el árbol**: 291497
    - **Finalizó con valor óptimo**: sí
    - **Tiempo total**: 67.169276 s

- Prueba 5: similar a prueba 2 pero sin output de consola en cada paso, y con las pequeñas optimizaciones de
performance también incluidas de la prueba 3
    - **Tour**: 11 ciudades
    - **Cota superior**: heurística de vecino más cercano
    - **Cota inferior**: algoritmo húngaro
    - **Cantidad de nodos en el árbol**: 113143
    - **Finalizó con valor óptimo**: sí
    - **Tiempo total**: 175.111972 s

## Conclusión

* El problema parece sencillo, pero posee muchas variantes que tieneesconde ciertos detalles No
