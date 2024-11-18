# --------------------------------------------------------------------------- #
# Méthode pour créer l'ensemble des alpha-meilleures solutions x0

function constructionSolution(C, A, alpha)
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
            nbAGarder = size(ensembleDeSolutions)[1] - Int(round(alpha*size(ensembleDeSolutions)[1]))
            if nbAGarder == 0
                nbAGarder = 1
            end
            ensembleDeSolutions = last(ensembleDeSolutions, nbAGarder)
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

function grasp(C,A,tour,alpha)
    bestSol = 0
    bestScore = 0
    for i=1:tour
        solution,score = (constructionSolution(C,A,alpha))
        solution,score = decente(C,A,solution,score)
        if score > bestScore
            bestScore = score
            bestSol = solution
        end
    end

    return (bestScore,bestSol)

end