function test(C, A, solutionATester, scoreABattre)
    
    m, n = size(A)
    final = zeros(Int,m)
    reponseAcceptee = true

    for i = 1:size(solutionATester)[1]
    
        if solutionATester[i] == 1

            for j = 1:m
                final[j] += A[m*(i-1)+j]
            end
        end
    end

    for i =1:size(final)[1]
        if final[i] > 1
            reponseAcceptee = false
        end
    end

    if reponseAcceptee
        score = 0
        for i=1:size(solutionATester)[1]
            if solutionATester[i] == 1
                score += C[i]
            end
        end
        if score > scoreABattre
            return(["O",solutionATester,score])
        else
            return(["N",[],0])
        end
    else
        return(["N",[],0])
    end
end
            
function decente(C, A, solutionx0,score)
    solutiondepart = copy(solutionx0)
    solutionTrouvee = true

    while solutionTrouvee
        solutionTrouvee = false
        for i = 1:size(solutionx0)[1]

            if solutionx0[i] == 1

                for j = 1:size(solutionx0)[1]

                    if solutionx0[j] == 0

                        solution2 = copy(solutionx0)
                        solution2[i] = solutionx0[j]
                        solution2[j] = solutionx0[i]

                        retour = ["N",[],0]
                        if solutionTrouvee == false
                            retour = test(C,A,solution2,score)
                        end

                        if retour[1] == "O"
                            solutionx0 = retour[2]
                            score = retour[3]
                            solutionTrouvee = true
                        end
                        

                    end

                end

            end

        end
    end
    if solutiondepart == solutionx0
        println("Pas d'améliorations après la décente")
    else
        println("Amélioration de la solution ", solutiondepart, " en ", solutionx0, " grace à l'algorythme de décente")
    end
    return(solutionx0,score)
end
