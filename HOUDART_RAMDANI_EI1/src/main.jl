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

# =========================================================================== #

## Loading a SPP instance
#println("\nLoading...")
fname = "dat/pb_2000rnd0800.dat"
C, A = loadSPP(fname)
#@show C
#@show A

#elapsed_time = @elapsed begin
#tblUse,score = constructionX0(C, A)
#
#println("On a une solution x0 avec glouton de ", score, " avec comme solution ", tblUse)
#
#println("On applique un algorythme de décente sur cette solution")
#tblUse,score = decente(C,A,tblUse,score)
#end
#println(elapsed_time)


# Solving a SPP instance with GLPK
#elapsed_time = @elapsed begin
#println("\nSolving...")
#solverSelected = GLPK.Optimizer
#spp = setSPP(C, A)
##println(spp)
#
#set_optimizer(spp, solverSelected)
#optimize!(spp)
#
## Displaying the results
#println("z = ", objective_value(spp))
#print("x = "); println(value.(spp[:x]))
#end
#println(elapsed_time)

# =========================================================================== #

#Collecting the names of instances to solve
table_CPUtime = []
table_z = []
table_CPUtime2 = []
table_z2 = []

println("\nCollecting...")
target = "dat"
fnames = getfname(target)

for i = 1:size(fnames)[1]
    C , A = loadSPP("dat\\"*fnames[i]::String)
    solverSelected = GLPK.Optimizer
    #tps = @elapsed begin
    #    tblUse,score = constructionX0(C, A)
    #    tblUse,score = decente(C,A,tblUse,score)
    #end
    tps2 = @elapsed begin
        spp = setSPP(C, A)
        set_optimizer(spp, solverSelected)
        optimize!(spp)
    end
    #push!(table_CPUtime,tps)
    #push!(table_z,score)
    push!(table_CPUtime2,tps2)
    push!(table_z2,objective_value(spp))
    println("Fichier ",i," réalisé")
end

for i = 1:size(fnames)[1]
    #println("Pour le fichier "*fnames[i]*"\nSans GLPK\n- Glouton + décente : ", table_CPUtime[i], " secondes\n- Z : ",table_z[i])
    println(fnames[i],"\nAvec GLPK\n- Glouton + décente : ", table_CPUtime2[i], " secondes\n- Z : ",table_z2[i])
    println("\n")
end


println("\nThat's all folks !")