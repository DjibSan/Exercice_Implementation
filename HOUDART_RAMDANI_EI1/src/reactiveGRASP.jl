function reactiveGRASP(C,A,pas,Nalpha,tours)
    nbTbl = Int(floor(1/pas))
    tblAlpha = []
    tblAvg = []
    tblqDek = []

    for i=pas:pas:1
        push!(tblAlpha,[i,1/nbTbl])
        push!(tblAvg,[i,0,0])
    end

    zBest = 0
    zWorst = 10^10

    for i = 1:nbTbl
        score,solution = grasp(C,A,1,tblAlpha[i][1])
        if score > zBest
            zBest = copy(score)
        end
        if score < zWorst
            zWorst = copy(score)
        end
        tblAvg[i][2] += score
        tblAvg[i][3] += 1
        
    end

    for i = 1:tours

        for j = 1:Nalpha
            alpha = nbAlea(tblAlpha)
            score,solution = grasp(C,A,1,tblAlpha[alpha][1])
            if score > zBest
                zBest = copy(score)
            end
            if score < zWorst
                zWorst = copy(score)
            end
            tblAvg[alpha][2] += score
            tblAvg[alpha][3] += 1
        end

        SommeqDei = 0
        for j = 1:size(tblAlpha)[1]
            zAvg = tblAvg[j][2]/tblAvg[j][3]
            push!(tblqDek,((zAvg - zWorst)/(zBest - zWorst)))
            SommeqDei += ((zAvg - zWorst)/(zBest - zWorst))

        end

        for j = 1:size(tblAlpha)[1]
            pDek = tblqDek[j]/SommeqDei
            pDek = floor(pDek, digits=5)
            if pDek == 0
                pDek == 0.000001
            end
            tblAlpha[j][2] = pDek
        end

    end
    return (zBest)
end
