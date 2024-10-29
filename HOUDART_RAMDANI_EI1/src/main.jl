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

# =========================================================================== #

fname = "dat/pb_500rnd0500.dat"
C, A = loadSPP(fname)
grasp(C,A,30,0.75)

tblUse,score = constructionX0(C, A)
tblUse,score = decente(C,A,tblUse,score)
println("")
println(score,tblUse)
# Choix du mode avec verification

#mauvais = true
#s = ""
#
#while mauvais
#    println("Est ce que vous preferez lancer 1 instance (One) ou l'ensemble des instances (11) (Multiple)  --> O/M.")
#    global s = readline() 
#
#    if (s == "O" || s == "M" || s == "o" || s == "m")
#        global mauvais = false
#    else
#        println("Ce n'est pas un input autorisé veuillez rééssayer.")
#
#    end
#end
#
#if (s == "O" || s == "o")
#    println("\nCollecting file names...")
#    target = "dat"
#    fnames = getfname(target)
#    mauvais = true
#
#    while mauvais
#        println("Entrez le nom du fichier à lancer")
#
#        global s = readline() 
#    
#        if (s in fnames)
#            global mauvais = false
#        else
#            println("Ce n'est pas un input autorisé veuillez rééssayer.")
#    
#        end
#    end
#
#    # Loading a SPP instance
#    println("\nLoading...")
#    fname = fnames[(findfirst(isequal(s), fnames))]
#    #fname = "dat/pb_2000rnd0800.dat"
#    C, A = loadSPP("dat\\"*fname)
#
#    #@show C
#    #@show A
#
#    elapsed_time = @elapsed begin
#    tblUse,score = constructionX0(C, A)
#
#    println("On a une solution x0 avec glouton de ", score, " avec comme solution ", tblUse)
#
#    println("On applique un algorythme de décente sur cette solution")
#    tblUse,score = decente(C,A,tblUse,score)
#
#    println("On uttilise GRASP")
#    
#    end
#    println("Temps réalisé : ", elapsed_time)
#
#    # Solving a SPP instance with GLPK
#    #elapsed_time = @elapsed begin
#    #println("\nSolving with GLPK...")
#    #solverSelected = GLPK.Optimizer
#    #spp = setSPP(C, A)
#    ##println(spp)
#    #
#    #set_optimizer(spp, solverSelected)
#    #optimize!(spp)
#    #
#    ## Displaying the results
#    #println("z = ", objective_value(spp))
#    #print("x = "); println(value.(spp[:x]))
#    #end
#    #println(elapsed_time)
#
#end
## =========================================================================== #
#
#if (s == "M" || s == "m")
#    #Collecting the names of instances to solve
#    table_CPUtime = []
#    table_z = []
#    table_CPUtime2 = []
#    table_z2 = []
#
#    println("\nCollecting...")
#    target = "dat"
#    fnames = getfname(target)
#
#    for i = 1:size(fnames)[1]
#        C , A = loadSPP("dat\\"*fnames[i]::String)
#        solverSelected = GLPK.Optimizer
#        #tps = @elapsed begin
#        #    tblUse,score = constructionX0(C, A)
#        #    tblUse,score = decente(C,A,tblUse,score)
#        #end
#        tps2 = @elapsed begin
#            spp = setSPP(C, A)
#            set_optimizer(spp, solverSelected)
#            optimize!(spp)
#        end
#        #push!(table_CPUtime,tps)
#        #push!(table_z,score)
#        push!(table_CPUtime2,tps2)
#        push!(table_z2,objective_value(spp))
#        println("Fichier ",i," réalisé")
#    end
#
#    for i = 1:size(fnames)[1]
#        #println("Pour le fichier "*fnames[i]*"\nSans GLPK\n- Glouton + décente : ", table_CPUtime[i], " secondes\n- Z : ",table_z[i])
#        println(fnames[i],"\nAvec GLPK\n- Glouton + décente : ", table_CPUtime2[i], " secondes\n- Z : ",table_z2[i])
#        println("\n")
#    end
#
#
#    println("\nThat's all folks !")
#end
