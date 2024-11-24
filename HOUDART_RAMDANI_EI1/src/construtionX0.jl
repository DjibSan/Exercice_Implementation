# --------------------------------------------------------------------------- #
# Mettre une solution x0 (avec l'algo glouton)

function constructionX0(C, A)

    # Instauration de variables
    m, n = size(A)
    solution = zeros(Int,n)
    contraintes = zeros(Int,m)
    ensembleDeSolutions = []
    pasFini = true
    score = 0
    cAutre = Float16[]

    # tant que une solution n'es pas finie
    while pasFini

        ensembleDeSolutions = []

        # Calcule le nb de 1 et le divise par le score pour chaque element sauf si il ne peut pas être ajouté
        for i =1:n
            vraiFaux = verifieBon(C,A,contraintes,i,solution)
            if vraiFaux
                push!(ensembleDeSolutions,[compteCDiviseParnb1(C,A,i),i])
            end
        end

        # si le tableau est vide, on finit la solution
        if isempty(ensembleDeSolutions)
            pasFini = false

        # sinon on ajoute la solution ou le score est le plus grand et et met a jour les contraintes
        else
            ensembleDeSolutions = sort!(ensembleDeSolutions)
            sol = ensembleDeSolutions[size(ensembleDeSolutions)[1]]
            for i=1:m
                contraintes[i] += A[size(A)[1]*(Int(sol[2])-1) + i]
            end

            solution[Int(sol[2])] = 1
        end
    end

    # Calcul du score
    for i = 1:n
        if solution[i] == 1
            score += C[i]
        end
    end

    return (solution,score)
end