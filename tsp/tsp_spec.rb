require_relative 'ejemplos/ejemplos'

def aserciones_para_ejemplo_4(resultado)
  expect(resultado[0]).to eq([0, 1, 2, 3, 0])
  expect(resultado[1]).to eq(6)
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

end

