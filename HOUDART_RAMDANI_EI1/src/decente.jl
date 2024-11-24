function decente(C, A, solutionx0,score)

    # en partant d'une solution de départ
    solutiondepart = copy(solutionx0)
    solutionTrouvee = true

    while solutionTrouvee
        solutionTrouvee = false

        # pour chaque 1, on va l'échanger avec un 0
        for i = 1:size(solutionx0)[1]

            if solutionx0[i] == 1

                for j = 1:size(solutionx0)[1]

                    if solutionx0[j] == 0

                        solution2 = copy(solutionx0)
                        solution2[i] = solutionx0[j]
                        solution2[j] = solutionx0[i]

                        retour = ["N",[],0]

                        # On va tester si la solution fonctionne et a un meilleur score que x0
                        if solutionTrouvee == false
                            retour = test(C,A,solution2,score)
                        end

                        # Si elle fonctionne et a un meilleur score, on change x0 
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
    return(solutionx0,score)
end