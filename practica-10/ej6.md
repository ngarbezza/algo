## Ejercicio 6

La idea es ir llevando siempre registro de los estados en los que estamos simultáneamente en cada patrón.

Ejemplo:

- T: abccaab
- P: bcc
- P': cca
- cuando la cadena leída hasta el momento sea:
    - 'a' entonces estamos en el estado 0 (no encontré nada) en P y 0 (no encontré nada) en P'
    - 'ab' entonces estamos en el estado 1 (encontré una b) en P y 0 (no encontré nada) en P'
    - 'abc' entonces estamos en el estado 2 (encontré una b y una c) en P y 1 (encontré una c) en P'
    - ... y así

1. Construir los autómatas de P y P' por separado.
2. Construir un nuevo autómata con todas las combinaciones posibles de estados de los autómatas del punto anterior,
   y todas las combinaciones de transiciones posibles entre ellos.
3. Eliminar los estados que queden inaccesibles.
