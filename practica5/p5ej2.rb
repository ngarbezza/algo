require_relative '../extensions/array'

def aulas_para_cursos(cursos)
  aulas = PQ.new
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

class PQElem
  include Comparable

  attr_accessor :obj, :priority

  def initialize(obj, priority)
    @obj, @priority = obj, priority
  end

  def <=>(other)
    @priority <=> other.priority
  end

  def ==(other)
    @priority == other.priority && @obj == other.obj
  end
end

class PQ
  # implementación sencilla de priority queue. Asume que
  # conceptualmente todas sus operaciones son O(log n)

  def initialize
    @elements = []
  end

  def <<(element)
    @elements << element
  end

  def pop
    last_element_index = @elements.size - 1
    @elements.sort!
    @elements.delete_at(last_element_index)
  end

  def find(predicate, if_found, if_not_found)
    for i in 0..@elements.size-1
      return if_found.call(@elements[i]) if predicate.call(@elements[i])
    end
    if_not_found.call
  end

  def remove(element)
    @elements.delete(element)
  end

  def to_s
    out = ''
    @elements.each do |element|
      out += "#{element.priority}: #{element.obj}\n"
    end
    out
  end
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
