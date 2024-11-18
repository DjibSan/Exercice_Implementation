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

fname = "didacticSPP.dat"
C, A = loadSPP("dat\\"*fname)
#tblUse,score = constructionX0(C, A)
#tblUse,score = decente(C,A,tblUse,score)
#println("")
#println("Score avec glouton : ", score)
#
#score,solution = grasp(C,A,30,0.8)
#println("Score avec Grasp : ",score)

#score,solution = reactiveGRASP(C,A,0.05,15,50)
#println("Score avec Reactive Grasp : ",score)
notreMeta(C,A)
