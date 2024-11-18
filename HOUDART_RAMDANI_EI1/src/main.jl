# =========================================================================== #
# Compliant julia 1.x

# Using the following packages
using JuMP, GLPK
using LinearAlgebra

include("loadSPP.jl")
include("setSPP.jl")
include("getfname.jl")
include("construtionX0.jl")
include("decente.jl")
include("GRASP.jl")
include("methodes.jl")
include("reactiveGRASP.jl")
include("notreMetaheuristique.jl")

# =========================================================================== #
# Choix du mode avec verification

s = questionReponses("Est ce que vous preferez lancer 1 instance (One) ou l'ensemble des instances (11) (Multiple)  --> O/M.",["O","o","M","m"])

if (s == "O" || s == "o")
    println("\nCollecting file names...")
    target = "dat"
    fnames = getfname(target)
    mauvais = true

    s = questionReponses("Entrez le nom du fichier à lancer",fnames)

    # Loading a SPP instance
    println("\nLoading...")
    fname = fnames[(findfirst(isequal(s), fnames))]
    C, A = loadSPP("dat\\"*fname)

    s = questionReponses("Choisissez votre algorythme de résolution (GD --> glouton + décente | G --> GRASP | RG --> ReactiveGRASP | 3 --> les 3)",["GD","gd","G","g","RG","rg","3"])
    s2 = questionReponses("Est ce que vous voulez rajouter une résolution par GLPK ? (O/N)",["O","o","N","n"])
    
    if (s == "GD" || s == "gd" || s == "3")
        println("Calcul de la solution glouton ...")
        
        t1 = @elapsed begin
            solution,score = constructionX0(C, A)
        end

        println("On a une solution X0 avec le glouton qui vaut ", score, "\nSolution : ", solution)
        println("Calcul de la décente ...")
        
        t2 = @elapsed begin
            solution,score = decente(C,A,solution,score)
        end

        println("On a une décente qui renvoie un score de ", score, "\nSolution : ", solution)
        println("Temps réalisé = ", (t1 + t2), " secondes")
    end

    if (s == "G" || s == "g" || s == "3")
        
        tour = questionReponsesO1("Combien de tour le GRASP doit réaliser ( <50 et INT )",50,true)
        alpha = questionReponsesO1("Quelle est la valeur de alpha ( entre 0 et 1 et FLOAT)",1)

        println("Calcul du GRASP ...")

        t1 = @elapsed begin
            score,solution = grasp(C,A,tour,alpha)
        end
        
        println("On a un GRASP avec un meilleur score de ", score, "\nSolution : ", solution)
        println("Temps réalisé = ", t1, " secondes")

    end

    if (s == "G" || s == "g" || s == "3")
        
        pas  = questionReponsesO1("Quel est le nombre de pas ( FLOAT entre 0 et 1 )",1)
        Nalpha = questionReponsesO1("Quelle est la valeur de Nalpha ( INT entre 0 et 100 )",100,true)
        tour = questionReponsesO1("Quel est le nombre de tours ( Int entre 1 et 100 )",100,true)

        println("Calcul du ReactiveGRASP ...")

        t1 = @elapsed begin
            score,solution,c = reactiveGRASP(C,A,pas,Nalpha,tour)
        end

        println("On a un GRASP avec un meilleur score de ", score, "\nSolution : ", solution)
        println("Temps réalisé = ", t1, " secondes")
        
    end
    
    if (s2 == "O" || s2 == "o")

        # Solving a SPP instance with GLPK
        println("\nSolving with GLPK...")
        solverSelected = GLPK.Optimizer
        
        elapsed_time = @elapsed begin
        spp = setSPP(C, A)
        #println(spp)
        set_optimizer(spp, solverSelected)
        optimize!(spp)
        end
        # Displaying the results
        println("z = ", objective_value(spp))
        print("x = "); println(value.(spp[:x]))
        
        println(elapsed_time)
    end

end
# =========================================================================== #

if (s == "M" || s == "m")
    #Collecting the names of instances to solve
    table_CPUtime = []
    table_z = []
    table_CPUtime2 = []
    table_z2 = []
    table_CPUtime3 = []
    table_z3 = []
    table_CPUtime4 = []
    table_z4 = []

    println("\nCollecting...")
    target = "dat"
    fnames = getfname(target)

    for i = 1:size(fnames)[1]
        println(fnames[i])
        C , A = loadSPP("dat\\"*fnames[i]::String)
        solverSelected = GLPK.Optimizer

        tps = @elapsed begin
            sol,score = constructionX0(C, A)
            sol,score = decente(C,A,sol,score)
        end

        tps2 = @elapsed begin
            score2,sol2 = grasp(C,A,20,0.75)
        end

        tps3 = @elapsed begin
            score3,sol3,c = reactiveGRASP(C,A,0.05,15,20)
        end

        tps4 = @elapsed begin
            spp = setSPP(C, A)
            set_optimizer(spp, solverSelected)
            optimize!(spp)
        end
        
        push!(table_CPUtime,tps)
        push!(table_z,score)
        push!(table_CPUtime2,tps2)
        push!(table_z2,score2)
        push!(table_CPUtime3,tps3)
        push!(table_z3,score3)
        push!(table_CPUtime4,tps4)
        push!(table_z4,objective_value(spp))
        println("Fichier ",i," réalisé")
    end

    for i = 1:size(fnames)[1]
        println("Pour le fichier "*fnames[i]*"\nSans GLPK\n- Glouton + décente : ", table_CPUtime[i], " secondes\n- Z : ",table_z[i])
        println("- GRASP (20,0.75) : ", table_CPUtime2[i], " secondes\n- Z : ",table_z2[i])
        println("- reactiveGRASP (0.05,15,20) : ", table_CPUtime3[i], " secondes\n- Z : ",table_z3[i])
        println("Avec GLPK : ", table_CPUtime4[i], " secondes\n- Z : ",table_z4[i])
        println("\n")
    end


    println("\nThat's all folks !")
end