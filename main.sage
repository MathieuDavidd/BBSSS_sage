#### file where I will call all the procedure to have the matrix of the msp and method to build secret ####

load("crt.sage") # fichier qui renvoie G pour tout les p < n
load("msp.sage") # fichier qui renvoie la matrice finale du msp 


G = crt_on_array(matrix_after_exp, prime_number) # appel du crt.sage avec des instruction hors function aussi (peut-être les enelever) et les mettre ici
#print("before gluing : ", matrix(G))
msp_mat = msp_matrix(G, m, n, k, t)

