# --------------------------------------------------------------------------- #
# Mettre une solution x0 (avec l'algo glouton)

function constructionX0(C, A)
  m, n = size(A)
  solution = zeros(Int,n)
  contraintes = zeros(Int,m)
  ensembleDeSolutions = []
  pasFini = true
  score = 0
  cAutre = Float16[]

  while pasFini
      ensembleDeSolutions = []
      for i =1:n
          vraiFaux = verifieBon(C,A,contraintes,i,solution)
          if vraiFaux
              push!(ensembleDeSolutions,[compteCDiviseParnb1(C,A,i),i])
          end
      end

      if isempty(ensembleDeSolutions)
          pasFini = false
      else
          ensembleDeSolutions = sort!(ensembleDeSolutions)
          sol = ensembleDeSolutions[size(ensembleDeSolutions)[1]]
          for i=1:m
              contraintes[i] += A[size(A)[1]*(Int(sol[2])-1) + i]
          end

          solution[Int(sol[2])] = 1
      end
  end
  
  for i = 1:n
      if solution[i] == 1
          score += C[i]
      end
  end

  return (solution,score)

end
