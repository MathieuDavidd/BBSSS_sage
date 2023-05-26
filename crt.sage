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
w = (i for i in Primes() if i<= 2*n)
j = next(w)
print("init j :",j)

matrix_before_exp = []
matrix_after_exp = [] # transposé mais au format array
alpha_before_exp = [] # pareil
prime_number = []


while j <=n:
	print("checkpoint pour le nombre premier : ", j) 
	prime_number.append(j)
	Fpm.<y> = GF(j**m)
	# now generate the matrix
	alpha_before_exp.append(reed_solomon_alpha(j, m, k, n, t))
	
	tempso1 = reed_solomon_array(j, m, k, n, t, alpha_before_exp[i], [])
	matrix_before_exp.append(tempso1)
	
	
	tempso = reed_solomon_ext_matrix(j,m,k,n,t, tempso1)
	matrix_after_exp.append(transpose_array_to_array(tempso)) # ca pose probleme
	j = next(w) # j is the iterator => prime number until n
		
	i+=1

# ici on a un tableau de matrices qui ont pour chaque nombres premiers puissance m

# ================================================================================================================================================================================
# Array of array (matrix expended) as input
# crt pour la matrice
def crt_on_array(array_list, prime_number):
	##### test before #####
	print("test before the program ")
	iterate_crt = len(array_list)
	print(iterate_crt)
	print("type dans la matrice")
	for i in range(iterate_crt):
		print(type(array_list[i][0][0]))
	
	
	dimy = len(array_list[0])
	
	dimx = len(array_list[0][0])
	print(dimx)
	print(dimy)
	values = []
	
	crt_solution = []
	#temp = []
	for i in range(dimy):
		temp = []
		for j in range(dimx):
			values = []
			#print("value")
			for k in range(iterate_crt):
				
				#print(array_list[k][i][j])
				#print(int(array_list[k][i][j]))
				values.append(int(array_list[k][i][j])) # retrieve the values for the crt application	
			
			
			temp.append(crt(values, prime_number))
			print(i*dimx + j)
		print(temp)
		crt_solution.append(copy.deepcopy(temp))
	
	print("after chinese remainder theorem :\n", Matrix(crt_solution))		
	return crt_solution

# faire la même chose pour les alpha_i

def crt_on_vector_array(array_list, prime_number):
	return 0

# voir comment faire pour le décodage et les nouveaux alpha_i
# ================================================================================================================================================================================

desired_matrix = crt_on_array(matrix_after_exp, prime_number)



