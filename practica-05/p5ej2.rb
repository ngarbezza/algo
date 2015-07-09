require_relative '../extensions/array'
require_relative '../data_structures/priority_queue'

def aulas_para_cursos(cursos)
  aulas = PriorityQueue.new
  cursos = ordenar_por_hora_de_inicio(cursos)
  cursos.each do |curso|
    aulas.find(
        lambda { |elem| curso_es_compatible?(curso, elem) },
        lambda { |elem| actualizar_aula(aulas, elem, curso) },
        lambda { agregar_aula(aulas, curso) }
    )
  end
  aulas
end

# Definiciones Auxiliares

def curso_es_compatible?(curso, elem)
  elem.priority <= curso[1]
end

def ordenar_por_hora_de_inicio(cursos)
  cursos.sort { |c1, c2| c1[1] <=> c2[1] }
end

def actualizar_aula(aulas, elem, curso)
  aulas.remove(elem)
  aulas << PQElem.new(elem.obj + [curso], curso[2])
end

def agregar_aula(aulas, curso)
  aulas << PQElem.new([curso], curso[2])
end

# Código de prueba

cursos = [
    [:historia, 2, 5],
    [:matematica, 5, 8],
    [:filosofia, 4, 6],
    [:geografia, 1, 4]
]
puts aulas_para_cursos(cursos).to_s
# aula 1: historia y matematica
# aula 2: geografia y filosofia
