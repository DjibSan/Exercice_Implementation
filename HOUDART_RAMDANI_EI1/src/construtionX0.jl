# --------------------------------------------------------------------------- #
# Mettre une solution x0 (avec l'algo glouton)

function constructionX0(C, A)
  m, n = size(A)
  final = zeros(Int,m)
  final2 = zeros(Int,n)
  cAutre = Float16[]
  score = 0

  #
  for i = 0:n-1
    nb1 = 0
    for j = 1:m
      if (A[j+i*m]) == 1
        nb1 +=1
      end
    end
    push!(cAutre,(C[i+1]/nb1))
  end

  cOrdre = sort(cAutre, rev=true)

  for i = 1:n

    for j = 1:n

      if cOrdre[i] == cAutre[j]

        tbl10 = []
        for k = 1:m
          push!(tbl10,A[(j-1)*m+k])
        end
        
        test = true
        for k = 1:m

          if tbl10[k] == 1 & final[k] == 1
            test = false
          end

        end

        if test
          final2[j] = 1

          for l = 1:m
            final[l] += tbl10[l]
          end

        end

      end

    end

  end

  for i = 1:n
    if final2[i] == 1
      score += C[i]
    end
  end

  return ([final2,score])

end