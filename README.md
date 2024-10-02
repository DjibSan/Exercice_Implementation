# Exercice_Impl-mentation_1

Heuristique de construction et recherche locale pour le “Set
Packing Problem (SPP)”
Cet exercice d’impl´ementation met en place les premi`eres briques visant l’´elaboration d’un solveur
pour le Set Packing Problem (SPP). Pour une instance num´erique disponible repr´esentant un SPP
quelconque :
1. Mettre en place une heuristique de construction d’une x0 r´ealisable.
2. Mettre en place une heuristique de recherche locale (descente ou plus profonde descente)
fond´ee sur deux voisinages (exemple : type “k-p exchange”).
3. Mener une exp´erimentation num´erique de vos algorithmes sur (au moins) 10 instances test
vari´ees, recueillir ˆz et CPUt.
4. Calculer les solutions optimales avec JuMP (ou GMP) et GLPK 1 ou HiGHS 2, recueillir ˜z
et CPUt ; discuter de ceux-ci vis-`a-vis des r´esultats approch´es obtenus.
5. Rapporter avec rigueur vos r´esultats dans le document LATEX (reprendre la trame `a votre
disposition sur madoc).
6. Votre solution logicielle reservira dans l’exercice d’impl´ementation n°2.
Des instances num´eriques de r´ef´erence de SPP sont fournies ; elles sont au format de la OR-library
et disponibles en ligne `a l’adresse http://www.emse.fr/~delorme/SetPackingFr.html.
Consignes `a respecter scrupuleusement
un livrable ne respectant pas ces consignes ne sera pas ´evalu´e, et aura pour note z´ero.
Votre solution informatique sera organis´ee dans un r´epertoire nomm´e votreNomEI1 contenant les
sous-r´epertoires suivants :
1. src
les fichiers sources en julia
2. dat
les fichiers de donn´ees
3. res
les fichiers de r´esultats
4. doc
les fichiers de documentation
L’ensemble sera rendu sous forme d’archive compress´ee avec zip, produisant un unique fichier
votreNomEI1.zip
