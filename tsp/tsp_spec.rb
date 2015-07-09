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

      context 'para 5 nodos' do

        it 'sin ninguna restricción' do
          restricciones = {ejes_que_tienen_que_estar: [], ejes_que_no_tienen_que_estar: []}
          resultado = calcular_cota_inferior(5, matriz_de_distancias(5), restricciones)

          expect(resultado).to eq(17.5) # ((3 + 2) + (3 + 3) + (4 + 4) + (2 + 5) + (3 + 6)).fdiv(2)
        end

        it 'con la restricción de que un eje debe estar' do
          restricciones = {ejes_que_tienen_que_estar: [[0, 4]], ejes_que_no_tienen_que_estar: []}
          resultado = calcular_cota_inferior(5, matriz_de_distancias(5), restricciones)

          expect(resultado).to eq(20) # ((2 + 7) + (3 + 3) + (4 + 4) + (2 + 5) + (3 + 7)).fdiv(2)
        end

        it 'con la restricción de que un eje NO debe estar' do
          restricciones = {ejes_que_tienen_que_estar: [], ejes_que_no_tienen_que_estar: [[0, 1]]}
          resultado = calcular_cota_inferior(5, matriz_de_distancias(5), restricciones)

          expect(resultado).to eq(18.5) # ((2 + 4) + (3 + 4) + (4 + 4) + (2 + 5) + (3 + 6)).fdiv(2)
        end

        it 'con más de una restricción' do
          restricciones = {ejes_que_tienen_que_estar: [[0, 2], [0, 4]], ejes_que_no_tienen_que_estar: [[0, 1], [0, 3]]}
          resultado = calcular_cota_inferior(5, matriz_de_distancias(5), restricciones)

          expect(resultado).to eq(23.5) # ((4 + 7) + (3 + 4) + (4 + 4) + (5 + 6) + (3 + 7)).fdiv(2)
        end

        it 'con todas las restricciones que conforman un tour' do
          restricciones = {ejes_que_tienen_que_estar: [[0, 1], [0, 3], [2, 3], [2, 4], [1, 4]],
                           ejes_que_no_tienen_que_estar: [[0, 2], [0, 4], [1, 2], [1, 3], [3, 4]]}
          resultado = calcular_cota_inferior(5, matriz_de_distancias(5), restricciones)

          expect(resultado).to eq(21) # ejes que conforman tour 0 -> 1 -> 4 -> 2 -> 3 -> 0 (21)
        end

      end

    end

    describe 'cálculo de cota superior'

  end

end

