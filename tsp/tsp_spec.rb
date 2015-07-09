require_relative 'ejemplos/ejemplos'

def aserciones_para_ejemplo_4(resultado)
  expect(resultado[0]).to eq([0, 1, 2, 3, 0])
  expect(resultado[1]).to eq(6)
end

def aserciones_para_ejemplo_5(resultado)
  expect(resultado[0]).to eq([0, 2, 1, 4, 3, 0])
  expect(resultado[1]).to eq(19)
end

def aserciones_para_ejemplo_11(resultado)
  expect(resultado[0]).to eq([0, 7, 4, 3, 9, 5, 2, 6, 1, 10, 8, 0])
  expect(resultado[1]).to eq(253)
end

describe 'TSP' do

  describe 'Backtracking' do

    it 'calcula la solución óptima para 4 ciudades' do
      aserciones_para_ejemplo_4 ejemplo_4(:backtracking)
    end

    it 'calcula la solución óptima para 5 ciudades' do
      aserciones_para_ejemplo_5 ejemplo_5(:backtracking)
    end

    it 'calcula la solución óptima para 11 ciudades (aunque tarda un poco...)' do
      aserciones_para_ejemplo_11 ejemplo_11(:backtracking)
    end

  end

  describe 'Greedy' do

    it 'calcula una solución para 4 ciudades, que justo en este caso coincide con la óptima' do
      aserciones_para_ejemplo_4 ejemplo_4(:greedy)
    end

    it 'calcula una solución para 11 ciudades, que no es la óptima' do
      resultado = ejemplo_11 :greedy

      expect(resultado[0]).to eq([0, 8, 7, 2, 10, 1, 4, 3, 5, 9, 6, 0])
      expect(resultado[1]).to eq(299)
    end

  end

  describe 'Branch and bound' do

    describe 'cálculo de cota inferior' do

      it 'sin ninguna restricción' do
        branch_and_bound = BranchAndBoundTSP.new(5)
        restricciones = RestriccionesTSP.new(5)

        resultado = branch_and_bound.cota_inferior(5, matriz_de_distancias(5), restricciones)

        expect(resultado).to eq(17.5) # ((3 + 2) + (3 + 3) + (4 + 4) + (2 + 5) + (3 + 6)).fdiv(2)
      end

      it 'con la restricción de que un eje debe estar' do
        branch_and_bound = BranchAndBoundTSP.new(5)
        restricciones = RestriccionesTSP.new(5)
        restricciones.incluir(0, 4)

        resultado = branch_and_bound.cota_inferior(5, matriz_de_distancias(5), restricciones)

        expect(resultado).to eq(20) # ((2 + 7) + (3 + 3) + (4 + 4) + (2 + 5) + (3 + 7)).fdiv(2)
      end

      it 'con la restricción de que un eje NO debe estar' do
        branch_and_bound = BranchAndBoundTSP.new(5)
        restricciones = RestriccionesTSP.new(5)
        restricciones.excluir(0, 1)

        resultado = branch_and_bound.cota_inferior(5, matriz_de_distancias(5), restricciones)

        expect(resultado).to eq(18.5) # ((2 + 4) + (3 + 4) + (4 + 4) + (2 + 5) + (3 + 6)).fdiv(2)
      end

      it 'con más de una restricción' do
        branch_and_bound = BranchAndBoundTSP.new(5)
        restricciones = RestriccionesTSP.new(5)
        restricciones.incluir(0, 2)
        restricciones.incluir(0, 4)
        restricciones.excluir(0, 1)
        restricciones.excluir(0, 3)
        resultado = branch_and_bound.cota_inferior(5, matriz_de_distancias(5), restricciones)

        expect(resultado).to eq(23.5) # ((4 + 7) + (3 + 4) + (4 + 4) + (5 + 6) + (3 + 7)).fdiv(2)
      end

      it 'con todas las restricciones que conforman un tour' do
        branch_and_bound = BranchAndBoundTSP.new(5)
        restricciones = RestriccionesTSP.new(5)
        restricciones.incluir(0, 1)
        restricciones.incluir(1, 4)
        restricciones.incluir(4, 2)
        restricciones.incluir(2, 3)
        restricciones.incluir(3, 0)
        resultado = branch_and_bound.cota_inferior(5, matriz_de_distancias(5), restricciones)

        expect(resultado).to eq(21) # ejes que conforman tour 0 -> 1 -> 4 -> 2 -> 3 -> 0 (21)
      end

    end

    describe 'cálculo de cota superior' do

      it 'sin ninguna restricción' do
        pending
        # asume que arranca desde el vértice 0
        restricciones = {ejes_que_tienen_que_estar: [], ejes_que_no_tienen_que_estar: []}
        resultado = cota_superior(5, matriz_de_distancias(5), restricciones)

        expect(resultado).to eq(21)
      end

      it 'con la restricción de que un eje debe estar' do
        pending
        restricciones = {ejes_que_tienen_que_estar: [[0, 4]], ejes_que_no_tienen_que_estar: []}
        resultado = cota_superior(5, matriz_de_distancias(5), restricciones)

        expect(resultado).to eq(20)
      end

      it 'con la restricción de que un eje NO debe estar' do
        pending
        restricciones = {ejes_que_tienen_que_estar: [], ejes_que_no_tienen_que_estar: [[0, 1]]}
        resultado = cota_superior(5, matriz_de_distancias(5), restricciones)

        expect(resultado).to eq(18.5)
      end

      it 'con más de una restricción' do
        pending
        restricciones = {ejes_que_tienen_que_estar: [[0, 2], [0, 4]], ejes_que_no_tienen_que_estar: [[0, 1], [0, 3]]}
        resultado = cota_superior(5, matriz_de_distancias(5), restricciones)

        expect(resultado).to eq(23.5)
      end

      it 'con todas las restricciones que conforman un tour' do
        pending
        restricciones = {ejes_que_tienen_que_estar: [[0, 1], [0, 3], [2, 3], [2, 4], [1, 4]],
                         ejes_que_no_tienen_que_estar: [[0, 2], [0, 4], [1, 2], [1, 3], [3, 4]]}
        resultado = cota_superior(5, matriz_de_distancias(5), restricciones)

        expect(resultado).to eq(21)
      end

    end

    describe 'búsqueda de una nueva restricción para branchear' do

      it 'retorna la opción 0,1 si no hay restricciones' do
        restricciones = RestriccionesTSP.new(2)

        expect(restricciones.posible_proxima_restriccion).to eq([0, 1])
      end

      it 'retorna la primer opción disponible (1,3) porque (1,2) no es factible' do
        restricciones = RestriccionesTSP.new(5)
        restricciones.incluir(0, 1)
        restricciones.incluir(0, 2)

        expect(restricciones.posible_proxima_restriccion).to eq([1, 3])
      end

      it 'lanza un error si ya existen todas las restricciones posibles (o sea, no se puede branchear más)' do
        restricciones = RestriccionesTSP.new(4)
        restricciones.incluir(0, 1)
        restricciones.incluir(0, 2)
        restricciones.excluir(0, 3)
        restricciones.excluir(1, 2)
        restricciones.excluir(1, 3)
        restricciones.incluir(2, 3)

        expect {restricciones.posible_proxima_restriccion}.to raise_error
      end

    end

    describe 'inferencia de restricciones' do

      describe 'al incluir un eje' do

        it 'no infiere nada más (agrega sólo la restricción nueva) si el conjunto inicial de restricciones es vacío' do
          restricciones = RestriccionesTSP.new(4)
          restricciones.incluir(0, 1)

          expect(restricciones.tiene_que_estar?(0, 1)).to eq(true)
          expect(restricciones.cantidad_de_inclusiones).to eq(1)
          expect(restricciones.cantidad_de_exclusiones).to eq(0)
        end

        it 'no infiere nada más (agrega sólo la restricción nueva) si la nueva restricción no tiene un efecto en las restricciones anteriores' do
          restricciones = RestriccionesTSP.new(4)
          restricciones.incluir(0, 1)
          restricciones.incluir(2, 3)

          expect(restricciones.tiene_que_estar?(0, 1)).to eq(true)
          expect(restricciones.tiene_que_estar?(2, 3)).to eq(true)
          expect(restricciones.cantidad_de_inclusiones).to eq(2)
          expect(restricciones.cantidad_de_exclusiones).to eq(0)
        end

        it 'infiere restricciones nuevas (para que pueda formarse un tour y/o para que no haya ciclos prematuros y/o para completar el tour cuando no hay otros ejes posibles para elegir)' do
          restricciones = RestriccionesTSP.new(4)
          restricciones.incluir(0, 1)
          restricciones.incluir(0, 2)

          expect(restricciones.tiene_que_estar?(0, 1)).to eq(true)    # porque ya estaba
          expect(restricciones.tiene_que_estar?(0, 2)).to eq(true)    # porque es la que agregamos
          expect(restricciones.no_tiene_que_estar?(0, 3)).to eq(true) # porque 0 ya tiene 2 ejes que deben estar
          expect(restricciones.no_tiene_que_estar?(1, 2)).to eq(true) # porque si estuviese, generaría un ciclo prematuro
          expect(restricciones.tiene_que_estar?(3, 1)).to eq(true)    # porque es una de las 2 aristas posibles para conectar a 3
          expect(restricciones.tiene_que_estar?(3, 2)).to eq(true)    # porque es una de las 2 aristas posibles para conectar a 3
          expect(restricciones.cantidad_de_inclusiones).to eq(2 + 2)
          expect(restricciones.cantidad_de_exclusiones).to eq(0 + 2)
        end

      end

      describe 'al excluir un eje' do

        it 'no infiere nada más (agrega sólo la restricción nueva) si el conjunto inicial de restricciones es vacío' do
          restricciones = RestriccionesTSP.new(5)
          restricciones.excluir(0, 1)

          expect(restricciones.no_tiene_que_estar?(0, 1)).to eq(true)
          expect(restricciones.cantidad_de_inclusiones).to eq(0)
          expect(restricciones.cantidad_de_exclusiones).to eq(1)
        end

        it 'no infiere nada más (agrega sólo la restricción nueva) si la nueva restricción no tiene un efecto en las restricciones anteriores' do
          restricciones = RestriccionesTSP.new(5)
          restricciones.excluir(0, 1)
          restricciones.excluir(2, 3)

          expect(restricciones.no_tiene_que_estar?(0, 1)).to eq(true)
          expect(restricciones.no_tiene_que_estar?(2, 3)).to eq(true)
          expect(restricciones.cantidad_de_inclusiones).to eq(0)
          expect(restricciones.cantidad_de_exclusiones).to eq(2)
        end

        it 'infiere restricciones nuevas (para que pueda formarse un tour y/o para que no haya ciclos prematuros y/o para completar el tour cuando no hay otros ejes posibles para elegir)' do
          restricciones = RestriccionesTSP.new(4)
          restricciones.excluir(0, 1)

          expect(restricciones.no_tiene_que_estar?(0, 1)).to eq(true) # porque ya estaba esa regla
          expect(restricciones.tiene_que_estar?(0, 2)).to eq(true)    # porque es uno de las 2 ejes posibles para conectar a 0
          expect(restricciones.tiene_que_estar?(0, 3)).to eq(true)    # porque es uno de las 2 ejes posibles para conectar a 0
          expect(restricciones.tiene_que_estar?(1, 2)).to eq(true)    # porque es uno de las 2 ejes posibles para conectar a 1
          expect(restricciones.tiene_que_estar?(1, 3)).to eq(true)    # porque es uno de las 2 ejes posibles para conectar a 1
          expect(restricciones.cantidad_de_inclusiones).to eq(0 + 4)
          expect(restricciones.cantidad_de_exclusiones).to eq(1)
        end

      end

    end

    describe 'ramificación' do

      it 'en un nodo sin restricciones, crea dos ramas con la primer inclusión/exclusión posible, y las asocia con el nodo padre' do
        branch_and_bound = BranchAndBoundTSP.new(5)
        nodo_inicial = branch_and_bound.nodo_inicial(5)
        ramas = branch_and_bound.ramificar(nodo_inicial)

        rama_izquierda = ramas[0]
        rama_derecha = ramas[1]
        expect(rama_izquierda[:padre]).to eq(nodo_inicial)
        expect(rama_derecha[:padre]).to eq(nodo_inicial)
        expect(rama_izquierda[:restricciones].tiene_que_estar?(0, 1)).to eq(true)
        expect(rama_izquierda[:restricciones].cantidad_de_inclusiones).to eq(1)
        expect(rama_derecha[:restricciones].no_tiene_que_estar?(0, 1)).to eq(true)
        expect(rama_derecha[:restricciones].cantidad_de_exclusiones).to eq(1)
      end

      it 'en un nodo con algunas restricciones, crea dos ramas eligiendo una opción de inclusión/exclusión de las posibles, y las asocia con el nodo padre'

    end

  end

end
