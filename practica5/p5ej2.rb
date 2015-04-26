require_relative '../extensions/array'

# TODO preguntar por complejidad en el peor caso

def aulas_para_cursos(cursos)
  aulas = []
  cursos.each do |curso|
    pude_asignar_curso = false
    aulas.each do |aula|
      if curso[2] <= aula[0]      # puede entrar antes que todos los cursos del aula
        aula[2].add_first curso
        aula[0] = curso[1]        # actualizar hora inicial del aula
        pude_asignar_curso = true
      elsif curso[1] >= aula[1]   # puede entrar después que todos los cursos del aula
        aula[2].add_last curso
        aula[1] = curso[2]        # actualizar hora final del aula
        pude_asignar_curso = true
      else
        # nada que hacer, el curso no se puede asignar en este aula
      end
    end
    unless pude_asignar_curso
      # necesito una nueva aula y asigno al curso ahí
      aulas << [curso[1], curso[2], [curso]]
    end
  end
  aulas
end


cursos = [
    [:historia, 2, 5],
    [:matematica, 5, 8],
    [:filosofia, 4, 6],
    [:geografia, 1, 4]
]
puts aulas_para_cursos(cursos).to_s
# aula 1: historia y matematica
# aula 2: geografia y filosofia
