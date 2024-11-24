# --------------------------------------------------------------------------- #

function constructionSolution(C, A, alpha)

    # Création d'une solution avec alpha
    m, n = size(A)
    solution = zeros(Int,n)
    contraintes = zeros(Int,m)
    ensembleDeSolutions = []
    pasFini = true
    score = 0
    cAutre = Float16[]

    # De la même manière que pour faire du glouton, on fait les mêmes étapes
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

            # mais on va garder les alpha% premières solutions
            nbAGarder = size(ensembleDeSolutions)[1] - Int(round(alpha*size(ensembleDeSolutions)[1]))
            if nbAGarder == 0
                nbAGarder = 1
            end
            ensembleDeSolutions = last(ensembleDeSolutions, nbAGarder)

            # et un va en prendre une au hasard parmi ces alpha% premières
            nb = rand((1:size(ensembleDeSolutions)[1]))
            sol = ensembleDeSolutions[nb]

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



function grasp(C,A,tour,alpha,var = true)

    bestSol = 0
    bestScore = 0

    # Pour x tours
    for i=1:tour

        # on construit une solution avec alpha
        solution,score = (constructionSolution(C,A,alpha))

        # on fait une décente sur cette solution
        if var
            solution,score = decente(C,A,solution,score)
        end

        # si le meilleur score est amélioré, alors on change le meilleur score
        if score > bestScore
            bestScore = score
            bestSol = solution
        end
    end

    return (bestScore,bestSol)

end