#------------------------------------------------------------------------------------
# fonction de création des individus
#------------------------------------------------------------------------------------

function creePopulation(C,A)
    # Faire un réactiveGRASP et récuperer le meilleur alpha a 0,5 près
    a,b,c = reactiveGRASP(C,A,0.1,5,5)
    #Population = 150

    population = []

    # Pour la 2/3 (100 individus) de la population, on va faire une distribution aux alentours du meilleur alpha
    # Distribution = 30 % à alpha = meilleur alpha, 15 % a alpha + et alpha - 0,05 10 % +- 0,1, 5% +- 0,15, 3 % +- 0,2, 2 % +- 0,25
    
    # Distribution des alphas
    for i = 1:30
        push!(population,[grasp(C,A,1,copy(c)),copy(c)])
    end
    for i = 1:15
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
    for i = 1:10
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
    for i = 1:5
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
    for i = 1:3
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
    for i = 1:2
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

#------------------------------------------------------------------------------------
# fonction de séléction
#------------------------------------------------------------------------------------

function selection(listPopulation)
    limite = 100
    popSuivante = []

    # séléction a base de roulettre truquée de 100 individus
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

#------------------------------------------------------------------------------------
# fonction d'évaluation
#------------------------------------------------------------------------------------

function evaluate(listPopulation)

    # calcule le fitness de chaque individu
    listPopulation = sort!(listPopulation, rev=true)
    population2 = []
    ttlScore = 0
    moyenneFitness = 0
    for i = 1:size(listPopulation)[1]
        ttlScore += listPopulation[i][1]
    end
    for i = 1:size(listPopulation)[1]
        fitness = listPopulation[i][1]/ttlScore
        moyenneFitness += fitness
        push!(population2,[listPopulation[i][1],listPopulation[i][2], fitness])
    end
    moyenneFitness = moyenneFitness/size(listPopulation)[1]

    # renvoie la séléction (fonction au dessus)
    return [selection(population2),moyenneFitness]
end

#------------------------------------------------------------------------------------
# fonction de crossover
#------------------------------------------------------------------------------------

function crossover(population)

    enfants = []

    # choix de 2 points de coupe au hasard
    for i = 1:size(population)[1]/2
        nb1 = rand(1:size(population)[1])
        parent1 = copy(population[nb1][2])
        deleteat!(population,nb1)
        nb2 = rand(1:size(population)[1])
        parent2 = copy(population[nb2][2])
        deleteat!(population,nb2)

        crossPoint1 = rand(1:size(parent1)[1])
        crossPoint2 = rand(1:size(parent1)[1])

        # coupe les parents et fait les enfants
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

        # ne garde que l'enfant 1 (pour 50 enfants qui remettent la population a 150)
        push!(enfants,enfant1)
    end
    return enfants
end

#------------------------------------------------------------------------------------
# fonction de mutation
#------------------------------------------------------------------------------------

function mutation(population)

    # si il y a une mutation, on change un 0 en 1/1 en 0 aléatoirement
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
        
        if nb <= 0.00000625 # 4 mutations
            push!(popRenvoi,faireMutation(faireMutation(faireMutation(faireMutation(population[i])))))
        elseif nb <= 0.000125 # 3 mutations
            push!(popRenvoi,faireMutation(faireMutation(faireMutation(population[i]))))
        elseif nb <= 0.0025 # 2 mutations
            push!(popRenvoi,faireMutation(faireMutation(population[i])))
        elseif nb <= 0.05 # 1 mutation
            push!(popRenvoi,faireMutation(population[i]))
        else
            push!(popRenvoi,population[i])
        end
    end
    return popRenvoi
end

#------------------------------------------------------------------------------------
# fonction qui regarde si la solution est amissible (très similaire a la partie sur les contraintes de x0)
#------------------------------------------------------------------------------------

function renvoieSibon(C,A,population)
    score = 0
    m, n = size(A)
    renvoieEnfentsValides = []
    for i = 1:size(population)[1]
        retour = true
        contraintes = zeros(Int,m)
        for j = 1:size(population[i])[1]
            if population[i][j] == 1
                contraintes += A[m*j-m+1:m*j]
            end
        end

        for j = 1:size(contraintes)[1]
            if contraintes[j] == 2
                retour = false
            end
        end

        if retour
            push!(renvoieEnfentsValides,population[i])
        end
    end

    return renvoieEnfentsValides
end

#------------------------------------------------------------------------------------
# fonction de calcul du score
#------------------------------------------------------------------------------------
function calculerLeScore(C,A,popEnfants)
    tbl = []
    # parcours tout les éléments, si c'est 1, alors on ajoute le score
    for i = 1:size(popEnfants)[1]
        score = 0
        for j = 1:size(popEnfants[i])[1]
            if popEnfants[i][j] == 1
                score += C[j]
            end
        end
        push!(tbl,(score,popEnfants[i]))
    end
    return tbl
end

#------------------------------------------------------------------------------------
# fonction d'ajou de 2 populations
#------------------------------------------------------------------------------------

function ajoutePopulation(popParents,popEnfants)
    tbl = []
    for i = 1:size(popParents)[1]
        push!(tbl,popParents[i])
    end
    for i = 1:size(popEnfants)[1]
        push!(tbl,popEnfants[i])
    end

    return tbl
end

#------------------------------------------------------------------------------------
# fonction de l'algo génétique
#------------------------------------------------------------------------------------

function algoGenetique(C,A,listPopulation)

    # évaluation des individus (voir la fonction plus haut) et garder que les 100 meilleurs 
    popSansEnfants,moyenneFitness = evaluate(listPopulation)
    
    popParents = []
    for i = 1:size(popSansEnfants)[1]
        push!(popParents,(copy(popSansEnfants)[i][1],copy(popSansEnfants)[i][2]))
    end
    
    # création des enfants de la population d'après (voir la foinction + haut)
    popEnfants = crossover(popSansEnfants)
    # mutation des enfants (voir la fonction + haut)
    popEnfants = mutation(popEnfants)
    # regarde si les enfants sont viables ou non, ne renvoie que les viables (voir la fonction + haut) (renvoie entre 0 et 50 enfants)
    popEnfants = renvoieSibon(C,A,popEnfants)
    # calcule le score des enfants pour la prochaine population (voir la fonction + haut)
    popEnfants = calculerLeScore(C,A,popEnfants)
    
    # ajoute la population des parents et des enfents entre eux (voir la fonction + haut)
    popSuivante = ajoutePopulation(popParents,popEnfants)
    popSuivante = sort(popSuivante, rev=true)
    return [popSuivante,moyenneFitness]
end

#------------------------------------------------------------------------------------
# méthode principale
#------------------------------------------------------------------------------------
# Le but de notre métaheuristique est de faire un algorythme genetique avec des solutions X0 
# basées sur du GRASP avec le meilleur alpha possible grâce au réactiveGRASP
# il y a une limite de 3 Min pour calculer

function notreMeta(C,A,var=false)

    mScore = []

    t1 = @elapsed begin

        # Creation de la population (voir + haut)
        population = creePopulation(C,A)
        # garder le meilleur score
        meilleurScore = copy(population[1][1][1])
        if var
            push!(mScore,copy(meilleurScore))
        end
        meilleurelement = copy(population[1][1][2])
        meilleurFitness = 0

        populationSuivante = []
        for i = 1:size(population)[1]
            push!(populationSuivante,population[i][1])
        end

        infTemps = true
    end

    temps = t1
    for i = 1:500

        # création de la population suivante
        t2 = @elapsed begin
            # voir au dessus pour la fonction de changement de population
            populationSuivante,moyenneFitness = algoGenetique(C,A,populationSuivante)

            # changement du meilleur score si trouvé
            if populationSuivante[1][1] > meilleurScore
                meilleurScore = copy(populationSuivante[1][1])
                meilleurelement = copy(populationSuivante[1][2])
            end

            if var
                push!(mScore,copy(meilleurScore))
            end
        end

        # update du temps
        temps += t2
        if temps > 180
            break
        end

    end

    if var
        return ([meilleurScore,meilleurelement,temps,mScore])
    else
        return ([meilleurScore,meilleurelement,temps])
    end
end