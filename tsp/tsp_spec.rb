require_relative 'ejemplos/ejemplos'

describe 'TSP' do

  describe 'Backtracking' do

    it 'calcula correctamente la solución para 4 ciudades' do
      resultado = ejemplo_4 :backtracking

      expect(resultado[0]).to eq([0, 1, 2, 3, 0])
      expect(resultado[1]).to eq(6)
    end

    it 'calcula correctamente la solución para 11 ciudades (aunque tarda un poco...)' do
      resultado = ejemplo_11 :backtracking

      expect(resultado[0]).to eq([0, 7, 4, 3, 9, 5, 2, 6, 1, 10, 8, 0])
      expect(resultado[1]).to eq(253)
    end

  end

end

