import copy
### fichier où on va combiner les matrices (qu'il faudra étendre dans l'expension de corps)
	# choisir un l tel que l > log(n)
	# générer une matrice p^l pour tout nombre premier 
	# faire l'expension de la matrice 
	# faire le crt 
	# renvoyer la grande matrice


# quand on ouvre sage math => d'abord load le code et ensuite attacher tout le reste (voir pour faire un script qui lance tout)
# load('reed_solomon_code.sage')




# init constants : settings 
n = 6	# petit n pour commencer 
k = 3	# arbitraire
t = 3


m = 3	# 2^3 = 8 > 6
# p pour chaque nombre premier


j = 2
i = 0 # iterator for indices in table
w = (i for i in Primes() if i<= n)


matrix_before_exp = []
matrix_after_exp = [] # transposé mais au format array
alpha_before_exp = [] # pareil
prime_number = []


while j <=n:
	print("checkpoint pour le nombre premier : ", j) 
	j = next(w) # j is the iterator => prime number until n
	prime_number.append(j)
	Fpm.<y> = GF(j**m)
	# now generate the matrix
	alpha_before_exp.append(reed_solomon_alpha(j, m, k, n, t))
	
	tempso1 = reed_solomon_array(j, m, k, n, t, alpha_before_exp[i], [])
	matrix_before_exp.append(tempso1)
	
	
	tempso = reed_solomon_ext_matrix(j,m,k,n,t, tempso1)
	print("tempso : ",tempso) 
	#matrix_after_exp.append(transpose_array_to_array()) # ca pose probleme
	
	i+=1
	
# ici on a un tableau de matrices qui ont pour chaque nombres premiers puissance m

# ================================================================================================================================================================================
# Array of array (matrix expended) as input
# crt pour la matrice
def crt_on_array(array_list, prime_number):
	#####
	iterate_crt = len(array_list)
	dimy = array_list[0]
	dimx = array_list[0][0]
	values = []
	
	crt_solution = []
	temp = []
	
	for i in range(dimy):
	
		for j in range(dimx):
			values = []
			for k in range(iterate_crt):
				values.append(array_list[k][i][j]) # retrieve the values for the crt application		
			temp.append(crt(values, prime_number))
		crt_solution.append(copy(temp))
	
	print("after chinese remainder theorem :", Matrix(crt_solution))		
	return crt_solution

# faire la même chose pour les alpha_i

def crt_on_vector_array(array_list, prime_number):
	return 0

# voir comment faire pour le décodage et les nouveaux alpha_i
# ================================================================================================================================================================================

desired_matrix = crt_on_array(matrix_after_exp, prime_number)



