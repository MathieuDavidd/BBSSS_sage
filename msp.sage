#### file where we'll construct the msp (the matrix) ####
import copy
load("vandermonde.sage")

# we take as input the desired G matrix as array
# return vectors and submatrix needed to construct the msp (list(g1, g2, ... gn) , list(N1, N2, ..., Ns)) ou les c sont des vecteurs lignes de taille m
def break_matrix(G, m):
	list_c = []
	list_N = []
	c = []
	N = []
	for i in range (len(G)):
		for j in range(len(G[0])):
			if (j == 0): # on ajoute dans la liste de vecteur
				c.append(G[i][j])
				if (i%m == m-1):
					list_c.append(copy.deepcopy(c))
					c = []
			else: # on ajoute dans list N
				
				if (j == 1):
					N.append([])
				
				N[i%m].append(G[i][j])
				
				if (i%m == m-1 and j == len(G[0]) -1):
					list_N.append(copy.deepcopy(N))
					N = []
						
	return list_c, list_N

"""
test rapide sur la fonction :
a = [[1,2,3,4],[1,2,3,4],[1,2,3,4],[1,2,3,4]]
c, n = break_matrix(a, 2)
print("c : ", c)
print("n : ", n)				
"""

# fonction qui serviront pour la construction de la matrice du msp



# gen_comb_n prend en entrée un nombre n et un taille => retourne l'ensemble des sous_ensemble de [n] de taille 'size'
def gen_comb_n(n,size):
	# perfom a conversion only for the gen comb
	def set_to_list(element):
		return list(element)

	vect = [i for i in range(n)]
	S = Subsets(vect, size)
	S = S.list()

	result = map(set_to_list, S) 
	return list(result)
	
"""
test rapide sur la fonction :
liste = gen_comb_n(4,2)
print(liste)
"""
#print(gen_comb_n(4,2))

# gen_sub_matrix prend en entrée un array de nombre ainsi qu'un taille et renvoie la liste des sous_tableau du tableau de taille mt*mt
def gen_sub_matrix(array, m, t):
	y = len(array)
	x = len(array[0])
	ite_y = y - m*t + 1
	ite_x = x - m*t + 1
	print("debug submatrix")
	sub_list = [] # list where all the submatrix should be stored
	
	for i in range(ite_y):
		for j in range(ite_x):
			sub_matrix = []
			# each iteration => get each submatrix
			for k in range(m*t):
				sub_vector = []
				for l in range(m*t):
					sub_vector.append(array[i+k][j+l])
				sub_matrix.append(copy.deepcopy(sub_vector))
			sub_list.append(copy.deepcopy(sub_matrix))
	print(sub_list)	
	return sub_list	


# gen_sub_matrix prend en entrée un array de nombre ainsi qu'un taille et renvoie la liste des sous_tableau du tableau de taille mt*mt mais en prenant les colones desordonnées
def gen_sub_matrix_unordered(array, m, t):
	y = len(array)
	x = len(array[0]) # c'est sur x qu'on va devoir faire une génération des combinaisons
	
	
	support = gen_comb_n(x, m*t) # censé renvoyer les combinaison des colones de la sous matrice /!\ les renvoie bien dans l'ordre => pratique
	#print("nb combinaison :", len(support))
	#print("support :", support)
	
	sub_list = [] # list where all the submatrix should be stored
	
	# support est une liste de liste
	for supp in support:
		sub_matrix = []
		for j in range (y):
			sub_vector = []
			for i in supp:
				sub_vector.append(array[j][i])
			sub_matrix.append(copy.deepcopy(sub_vector))
		sub_list.append(copy.deepcopy(sub_matrix))
			
	
	#print("array", array)
	#print(sub_list)	
	return sub_list	

"""
test rapide sur la fonction :
a = [[1,2,3, 4],[5,6,7,8],[9,10,11,12]]
gen_sub_matrix_unordered(a,2,1)		
"""

# return_n_s est une fonction qui doit retourner la sous matrice associée au sous ensemble de [n] S (qui est une liste) en paramètre => dans le papier on parle de mapping 
# surjectif mais ici on ne prendra en compte qu'un mapping bijectif : on va juste coller les matrices N_i une a une ou i appartient a S 
# ici on a juste a fusionner avec loperateur +
def return_n_s(list_N, S):
	result = []
	for i in S:
		result += list_N[i-1] # car il faut faire correspondre les indices et les listes
	#print(result)
	return result

"""
test pas très utile mais rapide sur la fonction :
a = [[[1,2],[3,4]],[[5,6],[7,8]], [[9,10],[11,12]]]
return_n_s(a,[1,3])
"""


# function qui doit retourner le produit ro(N) du papier : prend en entrée la liste des matrices Ni retournée par l'algorithme "break_matrix" (on suppose que la liste en entrée 
# est non null)
# /!\ on doit avoir le t (ou k) en paramètre
def ro(list_N, t):
	m = len(list_N[0])
	n = len(list_N)
	list_s = gen_comb_n(n, t) # doit générer tout les sous-ensembles de [n] de taille 't'
	
	product = 1
	debug = []
	debug_mat = []
	for s in list_s:
		NS = return_n_s(list_N, s)
		list_sub_mat = gen_sub_matrix_unordered(NS, m,t) # retourne les sous matrices de taille
		
		for mi in list_sub_mat:
			if matrix(mi).det() != 0:
				product *= matrix(mi).det()
				debug_mat.append(copy.deepcopy(mi))
				debug.append(matrix(mi).det())
	return product
# compliqué a tester un peu 

# split_ro prend en paramètre un nombre (qui est censé être le ro de la construction) et n, => doit renvoyer zeta_n et eta_n
def split_ro(ron, n):
	eta = 1
	zeta = 1
	F = factor(ron)
	F = list(F)
	#print("debug ro", ron)
	for i in F:
		(a,b) = i
		if a<=n:
			eta *= a**b
		else:
			zeta *= a**b
	return (zeta, eta)

"""
test pas très utile mais rapide sur la fonction :
a = 2016 # 2**5 * 3**2 * 7
(b,c) = split_ro(a,5)
print("zeta : ", b)
print("eta : ", c)
"""

# function that should return the glued matrix of the msp 
def msp_matrix(G, m, n, k): 
	msp_mat = []
	
	vector_sub_matrix = []
	list_c, list_N = break_matrix(G, m)
	
	# appel des fonctions définies plus haut
	ron = ro(list_N, k-1) # on récupère ro 
	#print("rho = ", ron)
	zeta, eta = split_ro(ron,n)
	#print("zeta = ", zeta)
	
	for i in range(n): # construction du block de matrice
		
		# premier vecteur 
		vector_sub_matrix = [] 
		vector_sub_matrix.append(delta_L(n,n)) # determinant d'une matrice carré
		temp = [0 for k in range (len(G[0])-1)]
		vector_sub_matrix += copy.deepcopy(temp)
		temp = ei(1+i, k) # t = k-1
		vector_sub_matrix += copy.deepcopy(temp)
		
		block_sub_matrix = []
		block_sub_matrix.append(copy.deepcopy(vector_sub_matrix))
		# fin du block 
		for j in range(m):
			vector_sub_matrix = []
			vector_sub_matrix.append(zeta * list_c[i][j])
			vector_sub_matrix.extend(list_N[i][j])
			vector_sub_matrix.extend([0 for l in range(k-1)])
			block_sub_matrix.append(copy.deepcopy(vector_sub_matrix))

		msp_mat += copy.deepcopy(block_sub_matrix)
		
	#print(matrix(msp_mat))	
	return msp_mat
	
""" difficile a tester aussi 
à voir plus tard
"""
			
		
		
	
	
	
	

