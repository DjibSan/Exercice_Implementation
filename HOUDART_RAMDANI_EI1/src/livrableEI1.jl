# Fonction pour charger une instance du problème de Set Packing (SPP)
function loadSPP(fname)
    f = open(fname)
    
    # Lecture du nombre de contraintes (m) et de variables (n)
    m, n = parse.(Int, split(readline(f)))
    
    # Lecture des coefficients des variables
    C = parse.(Int, split(readline(f)))
    
    # Construction de la matrice binaire des contraintes A (m x n)
    A = zeros(Int, m, n)
    
    for i = 1:m
        # Lecture du nombre d'éléments non nuls sur la contrainte i (non utilisé ici)
        readline(f)
        
        # Lecture des indices des éléments non nuls sur la contrainte i
        for valeur in split(readline(f))
            j = parse(Int, valeur)
            A[i, j] = 1  # Marque la variable présente dans la contrainte
        end
    end
    
    close(f)
    return C, A  # Retourne les coefficients et la matrice binaire des contraintes
end

# Fonction pour calculer les valeurs pondérées des variables et afficher chaque étape
function calculer_valeurs_pondérées(C, A)
    n = size(A, 2)  # Nombre de variables (colonnes)
    valeurs_pondérées = zeros(Float64, n)  # Vecteur pour stocker les valeurs pondérées
    
    println("=== Calcul des valeurs pondérées ===")
    # Calcul des valeurs pondérées pour chaque variable
    for j = 1:n
        # Nombre de 1 dans la colonne j de la matrice A
        nb_1 = sum(A[:, j])
        
        # Calcul de la valeur pondérée : C(j) / nombre de 1
        if nb_1 > 0
            valeurs_pondérées[j] = C[j] / nb_1
            println("Pour la variable x$j : Coefficient = ", C[j], ", Nombre de 1 = ", nb_1, ", Valeur pondérée = ", C[j], "/", nb_1, " = ", valeurs_pondérées[j])
        end
    end
    
    return valeurs_pondérées
end

# Fonction pour vérifier s'il y a un chevauchement
function pas_de_chevauchement(S, A, j)
    # S est la solution actuelle, A est la matrice, j est l'index de la colonne
    for i in 1:size(A, 1)  # Parcourir les lignes (ensembles)
        if S[i] == 1 && A[i, j] == 1
            return false  # Il y a chevauchement
        end
    end
    return true  # Aucun chevauchement
end

# Heuristique de construction gloutonne d'une solution réalisable x0 avec explication détaillée
function heuristique_gloutonne(C, A)
    n = length(C)  # Nombre de variables
    m = size(A, 1)  # Nombre de contraintes
    
    # Initialiser la solution S à 0 (aucune variable n'est sélectionnée)
    S = zeros(Int, m)
    
    # Calculer les valeurs pondérées pour chaque variable
    valeurs_pondérées = calculer_valeurs_pondérées(C, A)
    
    # Poids total de la solution
    poids_total = 0
    
    println("=== Début de la sélection gloutonne ===")
    # Tant qu'il y a des candidats disponibles
    while maximum(valeurs_pondérées) > 0
        # Sélectionner la variable avec la plus grande valeur pondérée
        j_meilleur = argmax(valeurs_pondérées)
        println("\nLa plus grande valeur pondérée est pour la variable x$j_meilleur avec une valeur de ", valeurs_pondérées[j_meilleur], " (Coefficient = ", C[j_meilleur], ")")
        
        # Vérifier s'il n'y a pas de chevauchement avec la solution actuelle
        if pas_de_chevauchement(S, A, j_meilleur)
            println("Aucun chevauchement détecté pour x$j_meilleur. Ajout à la solution.")
            # Ajouter la variable à la solution S (mettre à jour les 1 dans la solution)
            for i in 1:m
                if A[i, j_meilleur] == 1
                    S[i] = 1
                end
            end
            
            # Ajouter le coefficient correspondant au poids total
            poids_total += C[j_meilleur]
            println("Poids total actuel de la solution : ", poids_total)
        else
            println("Chevauchement détecté pour x$j_meilleur. Non ajouté à la solution.")
        end
        
        # Marquer la variable comme traitée en mettant sa valeur pondérée à -1
        valeurs_pondérées[j_meilleur] = -1
    end
    
    return S, poids_total
end

# Fonction principale pour résoudre le problème avec affichage détaillé
function resoudreSPP(fname)
    # Charger les coefficients et la matrice des contraintes
    C, A = loadSPP(fname)
    
    # Afficher la matrice A et les coefficients C
    println("=== Matrice des contraintes A ===")
    println(A)
    println("\n=== Coefficients des variables C ===")
    println(C)
    
    # Construire une solution réalisable x0 avec l'heuristique gloutonne
    solution, poids_total = heuristique_gloutonne(C, A)
    
    # Afficher la solution et le poids total
    println("\n=== Résultat final ===")
    println("Solution initiale x0 : ", solution)
    println("Poids total de la solution : ", poids_total)
end
