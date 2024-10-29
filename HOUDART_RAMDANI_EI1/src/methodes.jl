function compteCDiviseParnb1(C,A,col)
    nb1 = 0 
    for i=1:size(A)[1]
        nb1 +=(A[size(A)[1]*(col-1) + i] == 1)
    end
    return C[col]/nb1
end

function verifieBon(C,A,contraintes,col,solution)
    if solution[col] != 1
        renvoi = true
        colDeTest = copy(contraintes)
        for i=1:size(A)[1]
            if (colDeTest[i] += A[size(A)[1]*(col-1) + i]) > 1
                renvoi = false
            end
            colDeTest[i] += A[size(A)[1]*(col-1) + i]
        end
        return (renvoi)
    else
        return (false)
    end
end

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
