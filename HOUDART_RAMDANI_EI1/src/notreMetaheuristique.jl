function creePopulation(C,A)
    # Faire un réactiveGRASP et récuperer le meilleur alpha a 0,5 près
    a,b,c = reactiveGRASP(C,A,0.05,10,10)

    #Population = 150

    population = []

    # Pour les 2/3 (100 individus) de la population, on va faire une distribution aux alentours du meilleur alpha
        # Distribution = 30 % à alpha = meilleur alpha, 15 % a alpha + et alpha - 0,05 10 % +- 0,1, 5% +- 0,15, 3 % +- 0,2, 2 % +- 0,25
    
    for i = 1:30
        push!(population,[grasp(C,A,1,copy(c)),copy(c)])
    end
    for i = 1:30
        cPlus = copy(c) + 0.05
        cMoins = copy(c) - 0.05

        if isodd(i)
            if cPlus <= 1
                push!(population,[grasp(C,A,1,round(cPlus; digits = 3)),round(cPlus; digits = 3)])
            else
                push!(population,[grasp(C,A,1,round(c; digits = 3)),round(c; digits = 3)])
            end
        else
            if cMoins >= 0
                push!(population,[grasp(C,A,1,round(cMoins; digits = 3)),round(cMoins; digits = 3)])
            else
                push!(population,[grasp(C,A,1,round(c; digits = 3)),round(c; digits = 3)])
            end
        end
    end
    for i = 1:20
        cPlus = copy(c) + 0.1
        cMoins = copy(c) - 0.1
        if isodd(i)
            if cPlus <= 1
                push!(population,[grasp(C,A,1,round(cPlus; digits = 3)),round(cPlus; digits = 3)])
            else
                push!(population,[grasp(C,A,1,round(c; digits = 3)),round(c; digits = 3)])
            end
        else
            if cMoins >= 0
                push!(population,[grasp(C,A,1,round(cMoins; digits = 3)),round(cMoins; digits = 3)])
            else
                push!(population,[grasp(C,A,1,round(c; digits = 3)),round(c; digits = 3)])
            end
        end
    end
    for i = 1:10
        cPlus = copy(c) + 0.15
        cMoins = copy(c) - 0.15
        if isodd(i)
            if cPlus <= 1
                push!(population,[grasp(C,A,1,round(cPlus; digits = 3)),round(cPlus; digits = 3)])
            else
                push!(population,[grasp(C,A,1,round(c; digits = 3)),round(c; digits = 3)])
            end
        else
            if cMoins >= 0
                push!(population,[grasp(C,A,1,round(cMoins; digits = 3)),round(cMoins; digits = 3)])
            else
                push!(population,[grasp(C,A,1,round(c; digits = 3)),round(c; digits = 3)])
            end
        end
    end
    for i = 1:6
        cPlus = copy(c) + 0.20
        cMoins = copy(c) - 0.20
        if isodd(i)
            if cPlus <= 1
                push!(population,[grasp(C,A,1,round(cPlus; digits = 3)),round(cPlus; digits = 3)])
            else
                push!(population,[grasp(C,A,1,round(c; digits = 3)),round(c; digits = 3)])
            end
        else
            if cMoins >= 0
                push!(population,[grasp(C,A,1,round(cMoins; digits = 3)),round(cMoins; digits = 3)])
            else
                push!(population,[grasp(C,A,1,round(c; digits = 3)),round(c; digits = 3)])
            end
        end
    end
    for i = 1:4
        cPlus = copy(c) + 0.25
        cMoins = copy(c) - 0.25
        if isodd(i)
            if cPlus <= 1
                push!(population,[grasp(C,A,1,round(cPlus; digits = 3)),round(cPlus; digits = 3)])
            else
                push!(population,[grasp(C,A,1,round(c; digits = 3)),round(c; digits = 3)])
            end
        else
            if cMoins >= 0
                push!(population,[grasp(C,A,1,round(cMoins; digits = 3)),round(cMoins; digits = 3)])
            else
                push!(population,[grasp(C,A,1,round(c; digits = 3)),round(c; digits = 3)])
            end
        end
    end

    # Pour le reste de la population, on va lui donner un alpha aléatoire dans arrondi a la 3 ème décimale
    for i = 1:50
        alphaAlea = round(rand(1)[1]; digits = 3)
        push!(population,[grasp(C,A,1,alphaAlea),alphaAlea])
    end

    return population

end


# Le but de notre métaheuristique est de faire un algorythme de fourmi avec des solutions X0 
# basées sur du GRASP avec le meilleur alpha possible grâce au réactiveGRASP
# limite de 1 Min 30 pour calculer ?

function selection(listPopulation)
    limite = 100
    popSuivante = []

    while limite> 0
        for i = 1:size(listPopulation)[1]
            if limite >0
                rnd = rand()
                if rnd < 1-listPopulation[i][3]
                    push!(popSuivante,(listPopulation[i]))
                    limite -= 1
                end
            else
                break
            end
        end
    end

    return popSuivante
end

function evaluate(listPopulation)
    listPopulation = sort!(listPopulation, rev=true)
    ttlScore = 0
    for i = 1:size(listPopulation)[1]
        ttlScore += listPopulation[i][1][1]
    end
    for i = 1:size(listPopulation)[1]
        fitness = listPopulation[i][1][1]/ttlScore
        push!(listPopulation[i], fitness)
    end

    return selection(listPopulation)
end

function crossover(population)

    enfants = []

    for i = 1:size(population)[1]/2
        nb1 = rand(1:size(population)[1])
        parent1 = copy(population[nb1][1][2])
        deleteat!(population,nb1)
        nb2 = rand(1:size(population)[1])
        parent2 = copy(population[nb2][1][2])
        deleteat!(population,nb2)

        crossPoint1 = rand(1:size(parent1)[1])
        crossPoint2 = rand(1:size(parent1)[1])

            if crossPoint1 < crossPoint2
                copyCross1 = copy(crossPoint1)
                crossPoint1 = copy(crossPoint2)
                crossPoint2 = copyCross1
            end
        enfant1 = []
        for j = 1:size(parent1)[1]

            if j >= crossPoint1 && j <= crossPoint2
                push!(enfant1,copy(parent1[j]))
            else
                push!(enfant1,copy(parent2[j]))
            end
        end
        push!(enfants,enfant1)
    end
    return enfants
end

function mutation(population)
    function faireMutation(element)
        nb = rand(1:size(element)[1])
        if element[nb] == 0
            element[nb] = 1
        else
            element[nb] = 0
        end
        return element
    end
    # Chance de faire 1 mutation = 0.05
    # Chance de faire 2 mutation = 0.0025
    # Chance de faire 3 mutation = 0.000125
    # Chance de faire 4 mutation = 0.00000625

    popRenvoi = []

    for i = 1:size(population)[1]
        nb = rand()
        
        if nb <= 0.00000625
            push!(popRenvoi,faireMutation(faireMutation(faireMutation(faireMutation(population[i])))))
        elseif nb <= 0.000125
            push!(popRenvoi,faireMutation(faireMutation(faireMutation(population[i]))))
        elseif nb <= 0.0025
            push!(popRenvoi,faireMutation(faireMutation(population[i])))
        elseif nb <= 0.05
            push!(popRenvoi,faireMutation(population[i]))
        else
            push!(popRenvoi,population[i])
        end
    end
    return popRenvoi
end

function regardeSibon(C,A,population)
    score = 0
    m, n = size(A)
    contraintes = zeros(Int,m)
    for i = 1:size(population)[1]
        println(population[i])
        println(verifieBon(C,A,contraintes,i,population[i]))
    end
end

function algoGenetique(C,A,listPopulation)
    popSansEnfants = evaluate(listPopulation)
    popParents = []
    for i = 1:size(popSansEnfants)[1]
        push!(popParents,copy(popSansEnfants)[i][1])
    end
    popEnfants = crossover(popSansEnfants)
    popEnfants = mutation(popEnfants)
    popEnfants = regardeSibon(C,A,popEnfants)
    return popEnfants
end

function notreMeta(C,A)
    population = creePopulation(C,A)
    populationSuivante = algoGenetique(C,A,population)
    
end