function reactiveGRASP(C,A,pas,Nalpha,tours)
    nbTbl = Int(floor(1/pas))
    tblAlpha = []
    tblAvg = []
    tblqDek = []


    # Création de la tables des alphas avec le même pas entre les nombres (Ex: pas a 0.1, alors la table sera [0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9] et si le pas est a 0.33, alors la table sera [0.33;0.66;0.99])
    for i=pas:pas:1
        push!(tblAlpha,[i,1/nbTbl])
        push!(tblAvg,[i,0,0])
    end

    sBest = []
    zBest = 0
    zWorst = 10^10
    alphaBest = 0

    # pour éviter de diviser par 0 par la suite, on va faire 1 GRASP pour chaque alpha au début
    for i = 1:nbTbl
        # GRASP avec l'alpha
        score,solution = grasp(C,A,1,tblAlpha[i][1])
        #update du meilleur score si besoin
        if score > zBest
            zBest = copy(score)
            sBest = copy(solution)
            alphaBest = copy(tblAlpha[i][1])
        end
        if score < zWorst
            zWorst = copy(score)
        end
        # ajout du score moyen 
        tblAvg[i][2] += score
        tblAvg[i][3] += 1
        
    end

    # ensuite, pour chaque nombre d'actualisations du tableau (tours)
    for i = 1:tours

        # On fait un nombre de tours (Nalpha)
        for j = 1:Nalpha

            # choix d'un alpha aléatoire avec un tableau de probas (voir méthodes)
            alpha = nbAlea(tblAlpha)
            # grasp avec ce alpha aléatoire
            score,solution = grasp(C,A,1,tblAlpha[alpha][1])

            #update du meilleur score si besoin
            if score > zBest
                zBest = copy(score)
                sBest = copy(solution)
                alphaBest = copy(tblAlpha[alpha][1])
            end
            if score < zWorst
                zWorst = copy(score)
            end
            # ajout du score moyen 
            tblAvg[alpha][2] += score
            tblAvg[alpha][3] += 1
        end

        # mise a jour de la valeur de choix du alpha
        SommeqDei = 0
        for j = 1:size(tblAlpha)[1]
            zAvg = tblAvg[j][2]/tblAvg[j][3]
            push!(tblqDek,((zAvg - zWorst)/(zBest - zWorst)))
            SommeqDei += ((zAvg - zWorst)/(zBest - zWorst))

        end

        # si une valeur ed probabilité est a 0, on l'augmente un peu pour ne pas diviser par 0
        for j = 1:size(tblAlpha)[1]
            pDek = tblqDek[j]/SommeqDei
            pDek = floor(pDek, digits=5)
            if pDek == 0
                pDek == 0.000001
            end
            tblAlpha[j][2] = pDek
        end

    end
    return (zBest,sBest,alphaBest)
end