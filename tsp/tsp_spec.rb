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
        restricciones = RestriccionesTSP.new(5)

        resultado = cota_inferior(5, matriz_de_distancias(5), restricciones)

        expect(resultado).to eq(17.5) # ((3 + 2) + (3 + 3) + (4 + 4) + (2 + 5) + (3 + 6)).fdiv(2)
      end

      it 'con la restricción de que un eje debe estar' do
        restricciones = RestriccionesTSP.new(5)
        restricciones.incluir(0, 4)

        resultado = cota_inferior(5, matriz_de_distancias(5), restricciones)

        expect(resultado).to eq(20) # ((2 + 7) + (3 + 3) + (4 + 4) + (2 + 5) + (3 + 7)).fdiv(2)
      end

      it 'con la restricción de que un eje NO debe estar' do
        restricciones = RestriccionesTSP.new(5)
        restricciones.excluir(0, 1)

        resultado = cota_inferior(5, matriz_de_distancias(5), restricciones)

        expect(resultado).to eq(18.5) # ((2 + 4) + (3 + 4) + (4 + 4) + (2 + 5) + (3 + 6)).fdiv(2)
      end

      it 'con más de una restricción' do
        restricciones = RestriccionesTSP.new(5)
        restricciones.incluir(0, 2)
        restricciones.incluir(0, 4)
        restricciones.excluir(0, 1)
        restricciones.excluir(0, 3)
        resultado = cota_inferior(5, matriz_de_distancias(5), restricciones)

        expect(resultado).to eq(23.5) # ((4 + 7) + (3 + 4) + (4 + 4) + (5 + 6) + (3 + 7)).fdiv(2)
      end

      it 'con todas las restricciones que conforman un tour' do
        restricciones = RestriccionesTSP.new(5)
        restricciones.incluir(0, 1)
        restricciones.incluir(1, 4)
        restricciones.incluir(4, 2)
        restricciones.incluir(2, 3)
        restricciones.incluir(3, 0)
        resultado = cota_inferior(5, matriz_de_distancias(5), restricciones)

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

        expect(restricciones.posible_proxima_restriccion).to eq([0,1])
      end

      it 'retorna la primer opción disponible (1,2)' do
        restricciones = RestriccionesTSP.new(5)
        restricciones.incluir(0,1)
        restricciones.incluir(0,2)
        restricciones.excluir(0,3)
        restricciones.excluir(0,4)

        expect(restricciones.posible_proxima_restriccion).to eq([1,2])
      end

      it 'lanza un error si ya existen todas las restricciones posibles (o sea, no se puede branchear más)' do
        restricciones = RestriccionesTSP.new(4)
        restricciones.incluir(0,1)
        restricciones.incluir(0,2)
        restricciones.excluir(0,3)
        restricciones.excluir(1,2)
        restricciones.excluir(1,3)
        restricciones.incluir(2,3)

        expect {restricciones.posible_proxima_restriccion}.to raise_error
      end

    end

    describe 'inferencia de restricciones' do

      describe 'al incluir un eje' do

        it 'no infiere nada más (agrega sólo la restricción nueva) si el conjunto inicial de restricciones es vacío' do
          restricciones_iniciales = [
              [-1, 0, 0, 0],
              [ 0,-1, 0, 0],
              [ 0, 0,-1, 0],
              [ 0, 0, 0,-1]
          ]
          restriccion_a_agregar = [0, 1]
          restricciones_esperadas = [
              [-1, 1, 0, 0],
              [ 1,-1, 0, 0],
              [ 0, 0,-1, 0],
              [ 0, 0, 0,-1]
          ]
          nuevas_restricciones = con_restricciones_inferidas_al_incluir(restriccion_a_agregar, restricciones_iniciales)
          expect(nuevas_restricciones).to eq(restricciones_esperadas)
        end

        it 'no infiere nada más (agrega sólo la restricción nueva) si la nueva restricción no tiene un efecto en las restricciones anteriores' do
          restricciones_iniciales = [
              [-1, 1, 0, 0],
              [ 1,-1, 0, 0],
              [ 0, 0,-1, 0],
              [ 0, 0, 0,-1]
          ]
          restriccion_a_agregar = [2, 3]
          restricciones_esperadas = [
              [-1, 1, 0, 0],
              [ 1,-1, 0, 0],
              [ 0, 0,-1, 1],
              [ 0, 0, 1,-1]
          ]
          nuevas_restricciones = con_restricciones_inferidas_al_incluir(restriccion_a_agregar, restricciones_iniciales)
          expect(nuevas_restricciones).to eq(restricciones_esperadas)
        end

        # TODO: desglosar en 3 diferentes tests viendo qué restricciones se van agregando en qué momento
        it 'infiere restricciones nuevas (para que pueda formarse un tour y/o para que no haya ciclos prematuros y/o para completar el tour cuando no hay otros ejes posibles para elegir) si la restricción a agregar hace que haya 2 ejes adyacentes en algún vértice' do
          restricciones_iniciales = [
              [-1, 1, 0, 0],
              [ 1,-1, 0, 0],
              [ 0, 0,-1, 0],
              [ 0, 0, 0,-1]
          ]
          restriccion_a_agregar = [0, 2]
          restricciones_esperadas = [
              [-1, 1, 1,-1],
              [ 1,-1,-1, 1],
              [ 1,-1,-1, 1],
              [-1, 1, 1,-1]
          ]
          nuevas_restricciones = con_restricciones_inferidas_al_incluir(restriccion_a_agregar, restricciones_iniciales)
          expect(nuevas_restricciones).to eq(restricciones_esperadas)
        end

      end

      describe 'al excluir un eje' do

      end

    end

  end

end
